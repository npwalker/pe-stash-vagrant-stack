# PE Stash Vagrant Stack

The stash-server VM is setup to install stash in developer mode which is a 24-hour license.  If you remove that flag you have to get an evaluation license key which will last 30 days.  You may want to do that if you have something long standing to test. 

http://blogs.atlassian.com/2014/11/automating-stash-deployments/

You can reach the Stash UI on port 7990

username: admin
password: admin

The goal of the stack is to facilitate testing and understanding of how to use setup r10k with stash.  

The stack automates installation of the webhook on the puppet-master with some puppet code in site.pp.  It also places the script that should be run from the stash post receive hook in /opt/puppet/sbin on the stash server.

The final steps to setup the post receive hook are manual.  

1. Install the following stash plugin
 - https://marketplace.atlassian.com/plugins/com.ngs.stash.externalhooks.external-hooks
2.  Make sure your ssh key is setup for root on the puppet master and you've configured it for your stash user
 - https://confluence.atlassian.com/display/STASH/SSH+user+keys+for+personal+use
3. Configure a post-receive hook on your control repo
 - https://confluence.atlassian.com/display/STASH/Using+repository+hooks
 - The command to run is:
   - `/opt/puppet/sbin/stash_mco.rb -k -t https://puppet:puppet@puppet-master:8088/payload`
4. You can confirm it all works by tailing the webhook logs while pushing a change to your control repo
 - `tail -f -n 0 /var/log/webhook/*.log`


## Other Notes

This is based on the puppet-debugging-kit.  

https://github.com/Sharpie/puppet-debugging-kit
