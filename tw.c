#include <stdio.h>  
#include<stdlib.h>

int checksum(int data[],int a,int count)
{
  int c1=0,c2=0;
  int mod;
  if(a==1){mod=255;}
  else{mod=65535;c1=1;}

  for(int i=0;i<count;i++)
  {
      c1=(c1+data[i])%mod;
      c2=(c2+c1)%mod;
  }

  return c2*mod+c1;
}

int main()
{
    int a;
    while(1){
        printf("Enter\n1.Find Flecther checksum \n2. Find Addler checksum \n3.Exit\n");
        scanf("%d",&a);
        if(a==3)
            exit(0);
        int data[5],num;
        printf("Enter data in the range of 0-65535 for calculating Checksum:\n");
        scanf("%d",&num);
        int count=0,d_num=num;
        while(d_num>0){
            d_num = d_num/10;
            count++;
        }
        d_num=num;
        for(int i=count-1;i>=0;i--){
            data[i]=d_num %10;
            d_num=d_num/10;
        }

        int val = checksum(data,a,count);
        printf("Checksum = %d\n",val);

    }
    return 0;
}
