
#include "stdio.h"
#include "serial.h"


int main(void)
{
	int i = 0;
	
	char str[100];
		
	init_uart( );	//波特率57600，8N1(8个数据位，无校验位，1个停止位)

	printf("\n\rStart : \n\r");
	printf("Please Enter a value : \n\r");
	
	while(1)
	{
		i = 0;
		
		scanf("%s", str);

		sscanf(str,"%d", &i);
		printf("print interger : %d, 0x%x\n\r", i, i);
	}

	return 0;
}
