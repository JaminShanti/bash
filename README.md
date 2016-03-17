Jamin Shanti / Bash
===================


Table of contents
-----------------

  * [Technologies](#technologies)
  * [Project Structure](#project-structure)
  * [Contributing](#contributing)

Technologies
------------

* Bash Programming Language : [bash]

[bash]:    https://en.wikipedia.org/wiki/Bash_(Unix_shell)


### Projects


Configuration Management
------------------------

Here is the basic annotated structure of this application:


Entended to provided global checking for environments where other configuration management tools are not yet deployed.

Assumption:  You need to already have your ssh keys deployed to all targeted servers.  
I recommend [ssh-copy-id] to accomplish this.
Usage:  
    - Populate set_env_serverlist.sh with the groups of servers you want to collect information.
    - Populate the Sample_Script.sh with a script you would like to run on each of these servers.
    - Sweep_servers.sh will run on each group.
    
```
Sample output:  

-------------------------------
FIRST_SERVERLIST Environment...
-------------------------------
ServerName: server1
Red Hat Enterprise Linux Server release 5.9 (Tikanga)
------------------------------
ServerName: server2
Red Hat Enterprise Linux Server release 5.9 (Tikanga)
-------------------------------
ServerName: server3
Red Hat Enterprise Linux Server release 5.9 (Tikanga)
-------------------------------
SECOND_SERVERLIST Environment...
-------------------------------
ServerName: server4
Red Hat Enterprise Linux Server release 5.9 (Tikanga)
-------------------------------
ServerName: server5
Red Hat Enterprise Linux Server release 5.9 (Tikanga)
-------------------------------


        
```
[ssh-copy-id]:     http://linux.die.net/man/1/ssh-copy-id

Contributing
------------

I ♥ contributers!

If you want to contribute to this project, claim an issue
on the Issues tab, fork the project, and start working! When your feature
or bugfix is ready, create a merge request back upstream and we'll
take a look!


### Guidelines

In general, try to keep your code neat and readable, make sure the test suite
passes before creating a pull request, and we'd appreciate test coverage for
new features/bug fixes!