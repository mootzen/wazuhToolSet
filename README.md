# wazuhToolSet
Collection of scripts, tools, custom rules and decoders I personally created for my wazuh instance


## Scripts

### rename_xml.sh

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
