#!/usr/bin/env bash

# Login to 1Password.
# Assumes you have installed the OP CLI and performed the initial configuration
# For more details see https://support.1password.com/command-line-getting-started/
eval "$(op signin aaaaabest)"

# put our search string into a var
string="${1}"

# build a filter we can use to output our list of items that match.
#filter=".[] | .overview.title as \$t | select(\$t | index(\"${string}\")) | [\$t, .uuid] | @csv"
filter=".[] | .overview.title as \$t | select(\$t | index(\"${string}\")) | [\$t, .uuid] | @csv"

# load the results up into an array
readarray -t my_array < <(op list items | jq -r -c "${filter}")

# debug display the list of entries we stored in the array
#echo ""
#echo "printf my_array contents."
#printf '%s\n' "${my_array[@]}"
#echo ""

# now we create and present the operator with a list of choices to select the env var they're wanting.
echo "Please select an entry:"
select choice in "${my_array[@]}"; do
  [[ -n ${choice} ]] || { echo "Invalid choice. Please try again." >&2; continue; }
  break # valid choice was made; exit prompt.
done

# Because our array elements are a string and the two vars in the string we're interested in are seperated by a comma (,)
# we need to temporarily set our IFS to a comma.
IFS=$','

# Now when read ready our choice the two vars we want to store will be split by a comma
read -r title uuid <<<"${choice}"

# reset our IFS back to the bash default.
IFS=$'\n'

# now we need to lose the preceding and trailing double-quotes (") from our VARs
title="${title%\"}"
title="${title#\"}"

uuid="${uuid%\"}"
uuid="${uuid#\"}"

# uncomment if debugging.
#echo ""
#echo "title: [$title]; uuid: [$uuid]"
#echo ""

# Now that the ops has selected the record we're interested in, lets pull the item
ev=`op get item ${uuid}`

# Convert to base64 for multi-line secrets.
# The schema for the 1Password type 'Password' uses t as the label, and v as the value.
for row in $(echo ${ev} | jq -r -c '.details.sections[1].fields[] | @base64'); do
    _envvars() {
        echo ${row} | base64 --decode | jq -r ${1}
    }
    echo "Setting environment variable $(_envvars '.t')"
    export $(echo "$(_envvars '.t')=$(_envvars '.v')")
done