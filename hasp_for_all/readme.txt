���������� ��������� usbhasp �� ����������.

���������:
- Ubuntu 18/20/22 x64
- Debian 10 x86
- CentOS 7/8/9 x64
- Fedora 37 x64
- RedOS MUROM 7.3.2
- Astra Linux Orel 2.12

1. ������������� ���� usbhasp.tar.gz
$ tar -xzvf ./usbhasp.tar.gz

2. ��������� ����������� 
$ sudo ./usbhasp/install.sh

3. ����� ��������� ����� �������
$ sudo rm -rf ./usbhasp/
$ rm -f ./usbhasp.tar.gz

4. ����� ������ ����� � ����� /etc/usbhaspd/keys/
5. ������������� ������ usbhaspd
$ sudo systemctl restart usbhaspd

6. ����� ��������� ����������� ������ � hasp lm
$ usbhaspinfo
