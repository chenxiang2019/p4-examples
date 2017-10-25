#include <stdio.h>

int main() {
	for (int i = 0; i <= 9; i++) {
		for (int j = 1; j <= 9; j++) {
			printf("table_add l2_forward forward 00:00:00:00:%d%d:02 => 2\n", i, j);
		}
		printf("table_add l2_forward forward 00:00:00:00:%dA:02 => 2\n", i);
	}
	printf("table_add l2_forward forward 00:00:00:00:00:01 => 1\n");
	printf("table_add l2_forward forward 00:00:00:00:00:02 => 2\n");
	return 0;
}