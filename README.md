## Get Start

__Prerequisite__: docker enviroment

* clone this project then `cd` to sh-jupyter
* __before__ execute manager.sh you should `vim devops/nginx-data/confs/jupyter.conf` and config your jupyter web site 
* `sh manager.sh init [your name]` - like sh manager.sh huazhou
* `sh manager.sh build` - you should build jupyter images at the first time. Dockerfile is in devops/jupyter 
* `sh manager.sh run` - run nginx and jupyter docker, and default notebooks dir is `~/notebooks`
* `sh manager.sh clean` - clean enviroment when you remove this jupyter web site

## License

    Copyright 2017 huazhouwang.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
