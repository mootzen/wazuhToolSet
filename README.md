# wazuhToolSet
Collection of scripts, tools, custom rules and decoders I personally created for my wazuh instance


## Scripts

### rename_xml.sh

Renames xml-files in up to two directories by matching against keyword (non-recursive). Useful for disabling rulefiles in bulk

#### Make script executable
```
chmod +x rename_xml.sh
```
#### Usage 
```
./rename_xml.sh "keyword" "dir1" "dir2" 
```
#### example: rename all sysmon rules
```
./rename_xml.sh "sysmon" "/var/ossec/etc/rules/" "/var/ossec/ruleset/rules" 
```
### check_rule-id.sh

check if id is free or already in use

#### Make script executable
```
chmod +x check_rule-id.sh
```
#### Usage 
```
./check_rule-id.sh "rule.id"
```
