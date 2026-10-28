* Mixtape / Remix seminar: same entry point as the Cattaneo exercises.
* do "run_all.do"             runs the Hansen module
* do "run_all.do" "1"         also runs the Hansen module
* do "/path/run_all.do" "all" "/path/to/exercises"
version 18.0
args module project_dir
if `"`module'"' == "" local module "all"
if !inlist("`module'", "all", "1") {
    display as error "Module must be all or 1 for the Mixtape track."
    exit 198
}
if `"`project_dir'"' == "" local project_dir `"`c(pwd)'"'
cd `"`project_dir'"'
confirm file "run_all.do"
confirm file "modules/01.do"
local project_dir `"`c(pwd)'"'
do "modules/01.do" `"`project_dir'"'
