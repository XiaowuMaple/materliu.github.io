@ECHO OFF
COLOR 1A
ECHO ���ڿ�ʼ��ȡ����������Ϣ������

netsh interface ip set address name="��������" source=dhcp 
echo �޸�DNS,�Զ���ȡDNS...
netsh interface ip set dns name="��������" source=dhcp 

ipconfig /all > ./result.txt
echo ������nslookup ��Ϣ >> ./result.txt
nslookup http://vm.qplus.com >> ./result.txt
nslookup www.qplus.com >> ./result.txt
echo tracert info >> ./result.txt
tracert www.qplus.com >> ./result.txt
ECHO ���óɹ���
PAUSE
