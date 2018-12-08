Netuitive Docker Agent Release History
======================================

Version next  
----------------------------

Version 0.2.16
----------------------------

Version 0.2.16
----------------------------
- Update netuitive-agent to v0.7.5
- Add a default TCPCollector config
- Add ConsulCollector.conf to project config
- Add pkg concurrent-log-handler to fix locking, I/O errors when multiprocess logging to single file
- Make ConcurrentRotatingFileHandler default log handler in netuitive-agent.conf
- Add Docker Container Uptime feature to the NetuitiveDockerCollector
- Add support for UDP to PortCheckCollector

Version 0.2.15
----------------------------
- Exclude device mapper virtual drives from DiskSpaceCollector by default
- Update netuitive-agent to v0.7.4

Version 0.2.14
----------------------------
- Update netuitive-agent to v0.7.3

Version 0.2.13
----------------------------
- Add a SimpleCollector config (off by default)
- Add minimal mode (off by default) option to the NetuitiveDockerCollector
- Enable the BaseCollector by default
- Update netuitive-agent to v0.7.2

Version 0.2.12
---------------------------
- Update netuitive-agent.conf to be in line with upstream defaults.
- Add build notifications
- Update netuitive-agent to v0.6.7

Version 0.2.11
---------------------------
- pull linux agent 0.6.6 for various bug fixes including a slow memory leak

Version 0.2.10
---------------------------
- pull linux agent 0.6.3 for various bug fixes and performance improvements

Version 0.2.9
---------------------------
- clean poster elements at the end of its flush operation

Version 0.2.8
---------------------------
- add simple mode support for NetuitiveDockerCollector

Version 0.2.7 - Dec 06 2016
---------------------------
- add tag support
- fix for host metrics issue

Version 0.2.6 - Apr 14 2016
---------------------------
- updated to the latest version of the agent

Version 0.2.5 - unreleased
---------------------------

Version 0.2.4 - Mar 11 2016
---------------------------
- updated to the latest version of the agent
- add statsd support

Version 0.2.3 - Mar 01 2016
---------------------------
- add conf volume bind-mount to support using a local netuitive-agent.conf
- updated documentation

Version 0.2.1 - Dec 3 2015
---------------------------
- updated to the latest version of the agent

Version 0.1.8 - Nov 6 2015
---------------------------
- updated to the latest version of the agent

Version 0.1.7 - Sep 25 2015
---------------------------
- updated to the latest version of the agent
- remove redundant plugin

Version 0.1.6 - Aug 05 2015
---------------------------
- reduce size of image
- updated to the latest version of the agent

Version 0.1.4 - Jul 01 2015
---------------------------
- initial release
