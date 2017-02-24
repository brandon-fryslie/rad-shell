Docker plugin

This plugin is awesome

## dhost

dhost is a command that lets you easily switch your docker host.

Will search known ssh hosts and history for completions if you press 'tab'.

### Usage
Call `dhost` with no arguments to print your current DOCKER_HOST.

Call `dhost host_string` to set your DOCKER_HOST with default port of 2375

Call `dhost host_string port_number` to set the DOCKER_HOST and the port

#### `dhost-alias`

Use this to define aliases for dhost.

dhost-alias red my-docker-host-01
dhost-alias orange my-docker-host-02
dhost-alias yellow my-docker-host-03

#### `DHOST_PATTERN`
- Specify this environment variable to output from your ssh hosts in the completion list.  I set mine to `"docker\|swarm" `

#### `dhost_custom_resolver`
- define a function named `dhost_custom_resolver` to have more finely grained control over the output

For example, this will set your dockerhost to 'docker-host-n' only if you enter a number:
```sh
dhost_custom_resolver() {
  [ ! -z "${1##*[!0-9]*}" ] && echo docker-host-${1}:4243
}
```

If this function doesn't print anything, `dhost my_host_string` will set your DOCKER_HOST to `tcp://my_host_string:2375`

## dsearch

Search running containers and print info.

Prints info for all containers matching the search string

Example:

If you have running containers that look like this:
```
e33945022636        gopher                 "/usr/bin/launcher..."   17 minutes ago       Up 17 minutes       3000/tcp jenkinsjob7127_gopher_1
6ab6da5b290b        panda-node:latest        "/home/jenkins/bin..."   17 minutes ago       Up 17 minutes       10.32.28.97:34959->7001/tcp, 10.32.28.97:34958->8081/tcp jenkinsjob7127_alm_1
9f28d6f41fee        burro:latest           "/usr/local/bin/st..."   17 minutes ago       Up 17 minutes       443/tcp, 10.32.28.6:34934->80/tcp jenkinsjob7127_burro_1
758335ee7598        selenium-hub:latest    "/srv/start.sh"          17 minutes ago       Up 17 minutes       jenkinsjob7127_hub_1
76edbb42562c        zebra:latest              "/docker-entrypoin..."   17 minutes ago       Up 17 minutes       9300/tcp, 10.32.28.15:32981->9200/tcp jenkinsjob7127_elasticsearch_1
01807ba3c5c6        fox:latest            "/usr/bin/launcher..."   17 minutes ago       Up 17 minutes       10.32.28.92:34671->3000/tcp jenkinsjob7127_zuul_1
981cbedc08a7        kafka:latest             "/opt/kafka/start_..."   17 minutes ago       Up 17 minutes       9092/tcp jenkinsalmjobsalmguitests7127_kafka_1
30de5a19184f        zookeeper:latest         "/opt/zookeeper/bi..."   17 minutes ago       Up 17 minutes       2181/tcp jenkinsalmjobsalmguitests7127_zookeeper_1
401b12c02137        oracle-11g:alm           "/oracle/start"          17 minutes ago       Up 17 minutes       10.32.28.25:34061->1521/tcp jenkinsjob7127_db_1
2c38c5950cec        panda-node               "/usr/bin/supervisord"   17 minutes ago       Up 17 minutes silly_borg
1b5caf591669        panda-node               "/usr/bin/supervisord"   18 minutes ago       Up 18 minutes distracted_kowalevski
74eb6f3df3f2        panda-node               "/usr/bin/supervisord"   18 minutes ago       Up 18 minutes naughty_noether
e699c7016825        panda-node               "/usr/bin/supervisord"   32 minutes ago       Up 31 minutes awesome_kare
34e2676388e4        coyote-node            "/usr/bin/supervisord"   32 minutes ago       Up 32 minutes serene_mccarthy
55040a1f027a        gopher                 "/usr/bin/launcher..."   4 hours ago          Up 4 hours          3000/tcp jenkinsjob14106_gopher_1
```

Then running `dsearch zebra` will print information about all containers that
contain the string 'zebra' in the ID, image name, container name, or network
information.

Running `dsearch 3000` will provide this output:

```
2e072adc6686 gopher jenkinsjob3304_gopher_1 3000/tcp
5f7d4940c305 fox:latest jenkinsjob3304_zuul_1 10.32.28.22:35026->3000/tcp
55040a1f027a gopher jenkinsjob14106_gopher_1 3000/tcp
```

Running `dsearch gopher 3000` will provide this output:

```
2e072adc6686 gopher jenkinsjob3304_gopher_1 3000/tcp
55040a1f027a gopher jenkinsjob14106_gopher_1 3000/tcp
```

Add `-q` to only print the container ids

Running `dsearch -q gopher 3000` will provide this output:

```
2e072adc6686
55040a1f027a
```

Add `-a` to search exited containers as well

Example: `dsearch -a my_exited_container other_search_string`

## dfirst

Use `dsearch` semantics, but only print information about the first container.
By default, this will be the most recently started container.

## dlogs

Use `dfirst` semantics to view logs.  Show logs of first container that matches
the search strings.

## dkill

Kill the first container that matches the search strings.

## dexec

Run `docker exec` on the first container that matches the search strings.  Execs
`bash` by default.  Use `-c` to change the command:

`dexec -c env gopher jenkinsjob300`
