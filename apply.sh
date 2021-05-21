#!/usr/bin/env bash
#set -x 

dump_files () {
    delete=0
    if [[ -f ${1} ]]
    then
        echo "Processing ${1}"
    else
        prev_commit=$(git rev-parse @~)
        git checkout ${prev_commit} ${1}
        echo "Processing ${1}"
        delete=1
    fi
}

apply_state () {
    delete=0
    if [[ -f ${1} ]]
    then
        echo "Processing ${1}"
    else
        prev_commit=$(git rev-parse @~)
        git checkout ${prev_commit} ${1}
        echo "Processing ${1}"
        delete=1
    fi

    kind=$(grep -m 1 "kind:" ${1} | cut -d":" -f2 | awk '{$1=$1;print}')
    version=$(grep -m 1 "version:" ${1} | cut -d":" -f2 | awk '{$1=$1;print}')
    package=$(grep -m 1 "package:" ${1} | cut -d":" -f2 | awk '{$1=$1;print}')
    name=$(grep -m 1 "name:" ${1} | cut -d":" -f2 | awk '{$1=$1;print}')
    echo "${kind}/${version}/${package}/${name}"

    if [[ ${kind} == "ClusterGroup" ]]
    then
        if [[ delete -eq 1 ]]
        then
            tmc clustergroup delete ${name}
        else
            op=$(tmc clustergroup get ${name})
            if [[ $? -eq 0 ]]
            then
                echo "Already exists. Updating."
                tmc clustergroup update ${name} -f ${1}
            else
                echo "Does not exist. Creating."
                tmc clustergroup create -f ${1}
            fi
        fi
    fi

    if [[ ${kind} == "Cluster" ]]
    then
        if [[ delete -eq 1 ]]
        then
            tmc cluster delete ${name}
        else
            #op=$(tmc cluster get ${name} -o json)
            #search by name if the cluster exists in the global list
            tmc cluster list | grep ${name}
            if [[ $? -eq 0 ]]
            then
                echo "Found cluster ${name}"
                echo "get the m & p"
                tmc cluster list --name ${name} -o json  |  jq -c '.clusters[0]' > cluster-info.json
                mgmt=$(cat cluster-info.json | jq '.fullName.managementClusterName' | sed 's/\"//g')
                echo "managementClusterName: ${mgmt}"
                prov=$(cat cluster-info.json | jq '.fullName.provisionerName'| sed 's/\"//g')                
                echo "provisionerName:${prov}"                
                echo "Already exists. Updating."
                version=$(cat cluster-info.json | jq '.meta.resourceVersion' | sed 's/\"//g' )
                #sed -e "s/meta:/meta:\\n  resourceVersion: $version/g" ${1} > tmpfile.yaml
                ./cluster_patch_yaml.sh ${1} ${version} tmpfile.yaml
                echo $(cat tmpfile.yaml)                
                tmc cluster update ${name} -m ${mgmt} -p ${prov} -f tmpfile.yaml -v 9                
                rm tmpfile.yaml
                rm cluster-info.json
            else
                echo "Does not exist. Creating.${1}"
                tmc cluster create -f ${1}
            fi
        fi
    fi

    if [[ ${kind} == "Namespace" ]]
    then
        
        if [[ delete -eq 1 ]]
        then                        
            tmc cluster namespace delete ${name} --cluster-name ${clusterName}      
        else
            clusterName=$(grep -m 1 "clusterName:" ${1} | cut -d":" -f2 | awk '{$1=$1;print}')            
            #TODO: manage return code
            echo "Found cluster ${clusterName}"

            echo "get the m & p"
            tmc cluster list --name ${clusterName} -o json  |  jq -c '.clusters[0]' > cluster-info.json
            
            mgmt=$(cat cluster-info.json | jq '.fullName.managementClusterName' | sed 's/\"//g')
            echo "managementClusterName: ${mgmt}"

            prov=$(cat cluster-info.json | jq '.fullName.provisionerName'| sed 's/\"//g')                
            echo "provisionerName:${prov}"  

            tmc cluster namespace get ${name} --cluster-name ${clusterName} -m ${mgmt} -p ${prov} -o json > namespace.json            
            if [[ $? -eq 0 ]]
            then
                echo "Found namespace ${name}"                
                echo "Already exists. Updating."
                tmc cluster namespace update -f ${1} --cluster-name ${clusterName}                
            else
                echo "Does not exist. Creating."
                tmc cluster namespace create -f ${1}
            fi
            rm namespace.json
            rm cluster-info.json
        fi
    fi

    if [[ ${kind} == "Workspace" ]]
    then
        if [[ delete -eq 1 ]]
        then
            tmc workspace delete ${name}
        else
            op=$(tmc workspace get ${name})
            if [[ $? -eq 0 ]]
            then
                echo "Already exists. Updating."
                tmc workspace update ${name} -f ${1}
            else
                echo "Does not exist. Creating."
                tmc workspace create -f ${1}
            fi
        fi
    fi

    if [[ ${kind} == "ImagePolicy" ]]
    then
        #type=$(grep "type:" ${1} | cut -d":" -f2 | awk '{$1=$1;print}')
        type="image-policy"
        echo "${type}"
        if [[ ${package} == "vmware.tanzu.manage.v1alpha.workspace.policy" ]]
        then
            command="workspace"
            parent_name=$(grep "workspaceName:" ${1} | cut -d":" -f2 | awk '{$1=$1;print}')
        fi
        if [[ delete -eq 1 ]]
        then
            tmc ${command} ${type} delete ${name} --workspace-name ${parent_name}
        else
            op=$(tmc ${command} ${type} get ${name} --workspace-name ${parent_name})
            if [[ $? -eq 0 ]]
            then
                echo "Already exists. Updating."
                tmc ${command} ${type} update ${name} --workspace-name ${parent_name} -f ${1}
            else
                echo "Does not exist. Creating."
                tmc ${command} ${type} create -f ${1}
            fi
        fi
    fi

    if [[ ${kind} == "NetworkPolicy" ]]
    then
        #type=$(grep "type:" ${1} | cut -d":" -f2 | awk '{$1=$1;print}')
        type="network-policy"
        echo "Type ${type}"
        if [[ ${package} == "vmware.tanzu.manage.v1alpha.workspace.policy" ]]
        then
            command="workspace"
            parent_name=$(grep "workspaceName:" ${1} | cut -d":" -f2 | awk '{$1=$1;print}')
        fi
        if [[ delete -eq 1 ]]
        then
            tmc ${command} ${type} delete ${name} --workspace-name ${parent_name}
        else
            op=$(tmc ${command} ${type} get ${name} --workspace-name ${parent_name})
            if [[ $? -eq 0 ]]
            then
                echo "Already exists. Updating."
                tmc ${command} ${type} update ${name} --workspace-name ${parent_name} -f ${1}
            else
                echo "Does not exist. Creating."
                tmc ${command} ${type} create -f ${1}
            fi
        fi
    fi


    if [[ ${kind} == "IAMPolicy" ]]
    then
        if [[ ${package} == "vmware.tanzu.manage.v1alpha.workspace.iampolicy" ]]
        then
            command="workspace"
        fi
        workspaceName=$(grep -m 1 "workspaceName:" ${1} | cut -d":" -f2 | awk '{$1=$1;print}')
        if [[ delete -eq 1 ]]
        then
            tmc ${command} iam delete ${workspaceName}
        else
            op=$(tmc ${command} iam get-policy ${workspaceName})
            if [[ $? -eq 0 ]]
            then
                echo "Already exists. Updating."
                sed -n '/roleBindings/,$p' ${1} > tmpfile.yaml
                tmc ${command} iam update-policy ${workspaceName} -f tmpfile.yaml -v 9
                rm tmpfile.yaml
	    fi
        fi
    fi
}

while read line; do apply_state ${line}; done < <(git diff --name-only HEAD HEAD~1 | grep yaml)

#while read line; do dump_files ${line}; done < <(git diff --name-only HEAD HEAD~1 | grep yaml)

