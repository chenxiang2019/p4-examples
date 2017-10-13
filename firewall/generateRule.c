#include <stdio.h>

int main() {
	for (int i = 2; i <= 100; i++) {
		printf("table_add firewall forward 10.0.0.%d/24 10.0.0.%d 17 => 3\n", i, i+1);
	}
	printf("table_add firewall forward 10.0.0.1/24 10.0.0.2 17 => 2\n");
	return 0;
}
