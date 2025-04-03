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

##### Single ID
```
./check_rule-id.sh "rule.id"
```
##### ID-Range
```
./check_rule-id.sh start-id-end.id
```
##### Example: Range
```
./check_rule-id.sh 10000-10010
```
### map_rules.sh

creates a table with all used rule.id's, rule.description and rule filepath and saves it to a txt which then can be grepped or exported

#### Make script executable
```
chmod +x map_rules.sh
```
#### Usage 
```
./map_rules.sh
```
