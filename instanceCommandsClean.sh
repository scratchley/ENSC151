# for perf...
# To make this setting permanent, edit /etc/sysctl.conf too, e.g.:
echo '#Added by W. Craig Scratchley at SFU:' | sudo tee -a /etc/sysctl.conf
echo 'kernel.perf_event_paranoid = -1' | sudo tee -a /etc/sysctl.conf
echo 'kernel.kptr_restrict = 0' | sudo tee -a /etc/sysctl.conf


# update /etc/environment -- add entries for BOOST_INCLUDE and BOOST_LIB, etc ...
echo 'BOOST_INCLUDE="/usr/include"' | sudo tee -a /etc/environment
echo 'BOOST_LIB="/usr/lib/aarch64-linux-gnu"' | sudo tee -a /etc/environment
echo 'BOOST_POSTFIX=""' | sudo tee -a /etc/environment
echo 'BOOST_DEBUG_POSTFIX=""' | sudo tee -a /etc/environment
echo '# to enable reverse debugging with gdb' | sudo tee -a /etc/environment
echo 'LD_BIND_NOW=1' | sudo tee -a /etc/environment
