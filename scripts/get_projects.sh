#! /bin/bash
#
# get_projects.sh ---
#
# Manage the eighteen user project repositories as git submodules of this
# repository.  Each slot's repository URL comes from the "s<N>_source"
# entries in config.txt, and the version to use comes from the matching
# "s<N>_version" entry.  Whatever the repository is called upstream, it
# is checked out as dependencies/slot_<N>, so that everything downstream
# can refer to a slot by its number alone.
#
# Usage (run from the repository top level):
#
#	scripts/get_projects.sh [options] [<slot> ...]
#
#	  (no option)	  clone any project that is not yet a submodule and
#			  check out the version recorded in config.txt
#	  -s, --status	  report each slot without changing anything
#	  -u, --update	  also move already-cloned projects onto the version
#			  in config.txt (this is how you take an update:
#			  edit the branch or hash, then run this)
#	  -c, --clean	  remove every project submodule, returning the
#			  harness to its empty state
#	  -f, --force	  with --clean, remove a project even though it has
#			  uncommitted changes in it
#	  -n, --dry-run	  print what would be done
#	  -h, --help
#
#	<slot> is a slot number, 1 to 18.  With none given, all eighteen
#	are considered.
#
# VERSION PINNING.  The "s<N>_version" entry has two fields, a branch and
# a commit:
#
#	s3_version:	chipalooza	a4b21e0...
#
# The branch may be "(default)" or "-" to mean the remote's own default
# branch --- we do not assume "main", because these are eighteen
# independent repositories and some use "master".
#
# The commit is what actually freezes a tapeout.  It may be "(none)" or
# "-" to mean "track the branch", in which case this script records the
# hash it actually checked out back into config.txt.  So the sequence
#
#	scripts/get_projects.sh		# clone at the branch tip
#	git commit config.txt .gitmodules dependencies/
#
# leaves a config.txt that names an exact commit for every slot, and a
# later run of this script reproduces that state exactly.  A hash that is
# already recorded is never overwritten;  to move a project forward you
# edit config.txt yourself and run with --update.
#
# WHAT THIS SCRIPT DOES NOT DO.  It stages its work but never commits.
# Adding or moving a submodule changes .gitmodules and the gitlink in the
# index, and those belong in a commit you write, next to the config.txt
# change that motivated them.
#
#--------------------------------------------------------------------

# Not "set -e":  one unreachable repository out of eighteen should not
# abandon the other seventeen.  Failures are counted and reported.
set -u

config="config.txt"
depdir="dependencies"
nslots=18

mode="clone"
dryrun=0
force=0
slots=()

#--------------------------------------------------------------------

usage() {
    # Print the header comment, from the title line down to the rule
    # that closes it --- a line range would go stale on the next edit.
    awk 'NR >= 3 { if (/^#-----/) exit; sub(/^# ?/, ""); print }' "$0"
    exit 0
}

note() { echo "$@"; }
warn() { echo "$@" >&2; }

run() {
    if [ $dryrun -eq 1 ]; then
	echo "    would run: $*"
	return 0
    fi
    "$@"
}

#--------------------------------------------------------------------
# Pull one whitespace-separated field out of a config.txt entry.
# Comments are stripped;  a missing key or field yields an empty string.

config_field() {
    awk -v key="$1:" -v fld="$2" '
	{ sub(/#.*/, "") }
	$1 == key {
	    $1 = "";
	    n = split($0, a);
	    print (fld <= n ? a[fld] : "");
	    exit;
	}
    ' "$config"
}

# "(none)", "(default)", "-" and "" all mean "not specified".

unspecified() {
    case "$1" in
	""|"-"|"(none)"|"(default)"|"none"|"default") return 0 ;;
	*) return 1 ;;
    esac
}

# A URL is usable only if it names something past the host.  config.txt
# ships with placeholder entries like "https://github.com/" for slots
# that have no project yet, and those must be skipped, not cloned.

usable_url() {
    case "$1" in
	"") return 1 ;;
	*://*/?*) return 0 ;;	# scheme, host, and a non-empty path
	*@*:?*)   return 0 ;;	# scp-style  git@host:path
	*) return 1 ;;
    esac
}

is_submodule() {	# $1 = path
    git config -f .gitmodules --get "submodule.$1.url" >/dev/null 2>&1
}

head_of() {		# $1 = path;  prints the checked-out commit
    # "git -C <dir>" walks UP to the enclosing repository when <dir> is
    # not one itself.  For a submodule that is registered but not checked
    # out --- what anyone gets who clones this repository without
    # --recurse-submodules --- that silently returns the HARNESS
    # repository's HEAD, which then looks like a project sitting on some
    # unexpected commit.  A checked-out submodule always has a .git entry
    # (a file pointing into .git/modules), so require one.
    [ -e "$1/.git" ] || return 1
    git -C "$1" rev-parse HEAD 2>/dev/null
}

# Record a resolved commit hash back into config.txt, leaving the key and
# the branch field --- and the tabs around them --- exactly as they were.

record_commit() {	# $1 = slot, $2 = hash
    if [ $dryrun -eq 1 ]; then
	echo "    would record commit $2 for slot $1 in $config"
	return 0
    fi
    sed -i "s|^\(s$1_version:[ \t]*[^ \t]*[ \t]*\).*|\1$2|" "$config"
}

#--------------------------------------------------------------------
# Report one slot.  Sets the global "state" to one of:
#
#	unset	  no usable URL in config.txt
#	missing	  not a submodule yet
#	absent	  registered as a submodule but not checked out
#	frozen	  checked out at exactly the commit config.txt names
#	tracking  checked out, no commit recorded (branch tip)
#	differs	  checked out at some other commit than config.txt names
#	moved	  the URL in config.txt is not the submodule's URL

state=""
detail=""

examine() {		# $1 = slot
    local n="$1" path url branch commit have suburl
    path="$depdir/slot_$n"
    url=$(config_field "s${n}_source" 1)
    branch=$(config_field "s${n}_version" 1)
    commit=$(config_field "s${n}_version" 2)
    state=""; detail=""

    if ! usable_url "$url"; then
	state="unset"; detail="no project assigned"
	return
    fi
    if ! is_submodule "$path"; then
	state="missing"; detail="$url"
	return
    fi

    suburl=$(git config -f .gitmodules --get "submodule.$path.url")
    if [ "$suburl" != "$url" ]; then
	state="moved"; detail="config says $url, submodule says $suburl"
	return
    fi

    have=$(head_of "$path")
    if [ -z "$have" ]; then
	state="absent"; detail="registered but not checked out"
	return
    fi
    if unspecified "$commit"; then
	state="tracking"
	if unspecified "$branch"; then
	    detail="branch tip, at ${have:0:12}"
	else
	    detail="$branch, at ${have:0:12}"
	fi
	return
    fi
    # config.txt may hold an abbreviated hash;  compare on that length.
    if [ "${have:0:${#commit}}" = "$commit" ]; then
	state="frozen"; detail="${have:0:12}"
    else
	state="differs"; detail="want $commit, have ${have:0:12}"
    fi
}

#--------------------------------------------------------------------

do_status() {
    local n
    printf "  %-9s %-9s %s\n" "slot" "state" "detail"
    printf "  %-9s %-9s %s\n" "----" "-----" "------"
    for n in "${slots[@]}"; do
	examine "$n"
	printf "  %-9s %-9s %s\n" "slot_$n" "$state" "$detail"
    done
}

#--------------------------------------------------------------------
# Clone a slot that is not yet a submodule.

do_clone() {		# $1 = slot
    local n="$1" path url branch commit have
    path="$depdir/slot_$n"
    url=$(config_field "s${n}_source" 1)
    branch=$(config_field "s${n}_version" 1)
    commit=$(config_field "s${n}_version" 2)

    note "slot_$n: cloning $url"

    # -b records the branch in .gitmodules, which is what
    # "git submodule update --remote" later follows.  Without a branch
    # named in config.txt we let the remote's default stand.
    if unspecified "$branch"; then
	run git submodule add -- "$url" "$path" || return 1
    else
	run git submodule add -b "$branch" -- "$url" "$path" || return 1
    fi

    if ! unspecified "$commit"; then
	# The commit may predate the branch tip, or live on another
	# branch entirely, so fetch everything before reaching for it.
	run git -C "$path" fetch --tags origin >/dev/null 2>&1
	if ! run git -C "$path" checkout --detach "$commit" >/dev/null 2>&1; then
	    warn "slot_$n: ERROR commit $commit not found in $url"
	    warn "    (the clone is kept, sitting on its default branch;  most"
	    warn "    often this means the URL was changed but the old repo's"
	    warn "    hash was left behind.  Fix $config, then --update.)"
	    return 1
	fi
	run git add -- "$path"
	note "    at $commit (frozen)"
    elif [ $dryrun -eq 1 ]; then
	note "    would record the checked-out hash in $config"
    else
	have=$(head_of "$path")
	if [ -n "$have" ]; then
	    record_commit "$n" "$have"
	    note "    at ${have:0:12}, recorded in $config"
	else
	    warn "slot_$n: ERROR clone produced no commit"
	    return 1
	fi
    fi
    return 0
}

#--------------------------------------------------------------------
# Move an existing submodule onto whatever config.txt now says.

do_update() {		# $1 = slot
    local n="$1" path url branch commit have target
    path="$depdir/slot_$n"
    url=$(config_field "s${n}_source" 1)
    branch=$(config_field "s${n}_version" 1)
    commit=$(config_field "s${n}_version" 2)

    if [ "$state" = "moved" ]; then
	note "slot_$n: URL changed, re-pointing at $url"
	run git submodule set-url -- "$path" "$url" || return 1
	run git submodule sync -- "$path" >/dev/null || return 1
	run git -C "$path" remote set-url origin "$url" || return 1
    fi

    if [ "$state" = "absent" ]; then
	note "slot_$n: checking out registered submodule"
	run git submodule update --init -- "$path" || return 1
    fi

    run git -C "$path" fetch --tags origin >/dev/null 2>&1

    if unspecified "$commit"; then
	# No hash recorded:  take the tip of the branch, then record it,
	# so that "update" also leaves the slot frozen and reproducible.
	if unspecified "$branch"; then
	    target=$(git -C "$path" symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null)
	    target=${target#origin/}
	    [ -n "$target" ] || target="HEAD"
	else
	    target="$branch"
	fi
	note "slot_$n: moving to tip of $target"
	if ! run git -C "$path" checkout --detach "origin/$target" >/dev/null 2>&1; then
	    warn "slot_$n: ERROR branch $target not found"
	    return 1
	fi
	have=$(head_of "$path")
	run git add -- "$path"
	record_commit "$n" "$have"
	note "    at ${have:0:12}, recorded in $config"
    else
	note "slot_$n: moving to $commit"
	if ! run git -C "$path" checkout --detach "$commit" >/dev/null 2>&1; then
	    warn "slot_$n: ERROR commit $commit not found in $url"
	    return 1
	fi
	run git add -- "$path"
	note "    at $commit (frozen)"
    fi
    return 0
}

#--------------------------------------------------------------------
# Remove a project submodule completely.  The three gf180mcu_ocd_ip__*
# submodules are part of the harness itself and are never touched:  only
# paths matching dependencies/slot_<N> are considered here.

do_remove() {		# $1 = slot
    local n="$1" path
    path="$depdir/slot_$n"

    is_submodule "$path" || return 0

    # Removing a slot throws away its working tree.  Everything that is
    # committed and pushed comes back from config.txt, but edits that a
    # user made in place and has not committed are gone for good, so
    # they have to be asked about rather than assumed.
    # (a submodule's .git is a file pointing into .git/modules, not a
    # directory, so this has to be -e rather than -d)
    if [ $force -eq 0 ] && [ -e "$path/.git" ]; then
	if [ -n "$(git -C "$path" status --porcelain 2>/dev/null)" ]; then
	    warn "slot_$n: NOT removed --- it has uncommitted changes:"
	    git -C "$path" status --short 2>/dev/null | sed 's/^/        /' >&2
	    warn "    commit or discard them, or re-run with --force."
	    return 1
	fi
    fi

    note "slot_$n: removing"
    run git submodule deinit -f -- "$path" >/dev/null 2>&1

    # "git rm" on a submodule refuses outright while .gitmodules has
    # unstaged changes ("please stage your changes to .gitmodules or
    # stash them to proceed"), and an earlier --update in the same
    # session will have left exactly that.  Stage it first --- it is the
    # file being rewritten here anyway.  Do NOT paper over a failure by
    # deleting the directory: that would leave the gitlink in the index
    # and the section in .gitmodules, which is a worse state than not
    # having tried, and the next "git submodule add" would refuse.
    run git add -- .gitmodules >/dev/null 2>&1
    if ! run git rm -f -- "$path" >/dev/null 2>&1; then
	warn "slot_$n: ERROR could not remove the submodule from the index"
	warn "    (try \"git status\" --- .gitmodules may need attention)"
	return 1
    fi

    # deinit leaves the real repository behind in .git/modules so that a
    # later re-add reuses it;  for a clean slate that has to go too, or
    # the next "git submodule add" refuses, complaining that a module of
    # that name already exists.
    run rm -rf ".git/modules/$path"
    run rm -rf "$path"
    return 0
}

#--------------------------------------------------------------------

while [ $# -gt 0 ]; do
    case "$1" in
	-s|--status)	mode="status" ;;
	-u|--update)	mode="update" ;;
	-c|--clean)	mode="clean" ;;
	-n|--dry-run)	dryrun=1 ;;
	-f|--force)	force=1 ;;
	-h|--help)	usage ;;
	[1-9]|1[0-8])	slots+=("$1") ;;
	*)
	    warn "get_projects.sh: unrecognized argument \"$1\""
	    warn "Try \"get_projects.sh --help\"."
	    exit 1
	    ;;
    esac
    shift
done

if [ ! -f "$config" ] || [ ! -d .git ]; then
    warn "get_projects.sh: run this from the repository top level"
    warn "(no $config or no .git here)."
    exit 1
fi

if [ ${#slots[@]} -eq 0 ]; then
    for n in $(seq 1 $nslots); do slots+=("$n"); done
fi

[ $dryrun -eq 1 ] && note "(dry run --- nothing will be changed)"

failed=0
changed=0

case "$mode" in

status)
    do_status
    ;;

clean)
    for n in "${slots[@]}"; do
	examine "$n"
	case "$state" in
	    unset|missing) ;;
	    *)
		if do_remove "$n"; then changed=$((changed + 1))
		else failed=$((failed + 1)); fi
		;;
	esac
    done
    if [ $changed -eq 0 ] && [ $failed -eq 0 ]; then
	note "No project submodules to remove;  the harness is already empty."
    elif [ $changed -gt 0 ]; then
	note ""
	note "Removed $changed project submodule(s).  The recorded commits in"
	note "$config are left alone --- they are the freeze record, and a"
	note "re-run of get_projects.sh restores exactly what was removed."
	note "Commit .gitmodules and the removed paths when you are ready."
    fi
    ;;

clone|update)
    for n in "${slots[@]}"; do
	examine "$n"
	case "$state" in
	    unset)
		;;
	    missing)
		if do_clone "$n"; then changed=$((changed + 1))
		else failed=$((failed + 1)); fi
		;;
	    frozen)
		[ "$mode" = "update" ] && note "slot_$n: already at $detail"
		;;
	    absent)
		# Registered but not checked out, which is what anyone gets
		# who clones this repository without --recurse-submodules.
		# There is nothing to decide --- config.txt already names the
		# commit --- so a plain run materializes it rather than
		# sending a newcomer off to read about --update.
		if do_update "$n"; then changed=$((changed + 1))
		else failed=$((failed + 1)); fi
		;;
	    moved|differs)
		# Here config.txt and the checkout genuinely disagree, and
		# moving a project is a deliberate act, so it takes the flag.
		if [ "$mode" = "update" ]; then
		    if do_update "$n"; then changed=$((changed + 1))
		    else failed=$((failed + 1)); fi
		else
		    warn "slot_$n: $state ($detail)"
		    warn "    run with --update to bring it into line with $config"
		    failed=$((failed + 1))
		fi
		;;
	    tracking)
		if [ "$mode" = "update" ]; then
		    if do_update "$n"; then changed=$((changed + 1))
		    else failed=$((failed + 1)); fi
		fi
		;;
	esac
    done
    note ""
    if [ $changed -gt 0 ] && [ $dryrun -eq 0 ]; then
	note "$changed slot(s) changed.  Review and commit:"
	note "    git status"
	note "    git commit $config .gitmodules $depdir"
    elif [ $changed -eq 0 ] && [ $failed -eq 0 ]; then
	note "Nothing to do;  every slot already matches $config."
    fi
    ;;
esac

if [ $failed -gt 0 ]; then
    warn "$failed slot(s) had problems (see above)."
    exit 1
fi
exit 0
