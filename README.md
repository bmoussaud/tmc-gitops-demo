# tmc-gitops

This is a demo repo that showcases how the GitOps model might be used to create/manage TMC objects like LCM clusters, policies etc.

Tested with 
* tmc version: 0.2.1-7e9c62fc
* clustergroup

Based on https://www.youtube.com/watch?v=_ROS1xIBxmA

# Before
1. Create the Cluster Group defined in (tmc-objects/clustergroups/dev.yaml)
2. Create the dev cluster defined in [tmc-objects/clusters/dev-cluster-01.yaml]

# Demo

1. Update the Cluster Group defined in [tmc-objects/clustergroups/dev.yaml]
2. Create a new Cluster: duplicated the file [tmc-objects/clusters/dev-cluster-01.yaml] and change its name (#3)
3. Create a new Workspace
4. Apply policies on clusters
5. upgrade the dev cluster

