#include<sys/types.h> 
#include<sys/socket.h> 
#include<netinet/in.h> 
#include<sys/stat.h> 
#include<stdlib.h> 
#include<fcntl.h> 
#include<stdio.h>
int main(){
int s_socket,so_c,len,fd,s=1024;
char *buf=malloc(s); 
char fname[256];
struct sockaddr_in a;
s_socket=socket(AF_INET,SOCK_STREAM,0);
a.sin_family=AF_INET;
a.sin_addr.s_addr=INADDR_ANY;
a.sin_port=htons(6800);
bind(s_socket,(struct sockaddr*)&a,sizeof(a));
listen(s_socket,3);
len=sizeof(struct sockaddr_in);
so_c=accept(s_socket,(struct sockaddr*)&a,&len);
printf("The client is connected...\n");
recv(so_c,fname,235,0);
if((fd=open(fname,O_RDONLY,0))<0){
printf("File open failed!!!");
exit(0);
}
while(read(fd,buf,s)>0){
send(so_c,buf,s,0);
}
close(so_c);
return close(s_socket);
}












#include<sys/types.h> 
#include<netinet/in.h> 
#include<sys/stat.h> 
#include<stdlib.h> 
#include<fcntl.h> 
#include<stdio.h> 
int main(){
int c_socket,s=1024;
char *buf=malloc(s);
char fname[256];
struct sockaddr_in address;
c_socket=socket(AF_INET,SOCK_STREAM,0); 
address.sin_family=AF_INET; 
address.sin_port=htons(6800);
inet_pton(AF_INET,"127.0.0.1",&address.sin_addr); 
connect(c_socket,(struct sockaddr *)&address,sizeof(address)); 
printf("Enter file name: ");
scanf("%s",fname);
send(c_socket,fname,255,0); 
while(recv(c_socket,buf,s,0)>0) 
printf("%s",buf);
return close(c_socket); 
}
