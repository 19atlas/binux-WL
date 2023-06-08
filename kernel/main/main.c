#include "../headerlar/print.h"
#include "../headerlar/input.h"
#include "../headerlar/sleep.h"
#include "../headerlar/string.h"

#define cmpin(in, comp) \
	(strlen(in) == strlen(comp) && memcmp(in,comp,strlen(in)) == 0)

void kernel_main() {
	char* GSOD = "Your Computer has been got crashed while trying to make a Action.";
	print_clear();
	print_set_color(renk_beyaz, renk_siyah);
	print_str("Welcome To ");
	print_set_color(renk_sari, renk_yesil);
	print_str("B");
	print_set_color(renk_acik_yesil, renk_yesil);
	print_str("INUX");
	print_set_color(renk_beyaz, renk_siyah);
	print_str("!\n");

	while (1) {
		char* inputed_variable = input(">");
		if (cmpin(inputed_variable,"echo hi")) {
			print_str("Hi");
		} else if (cmpin(inputed_variable,"cat")) {
			print_str("meow ~w~");
		} else {
			print_str(inputed_variable);
		}
		print_str("\n");
	}

}
