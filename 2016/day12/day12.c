#include <stdio.h>

int main() {
  int a = 0;
  int b = 0;
  int c = 0;
  int d = 0;

line01: /* cpy 1 a */
  a = 1;
line02: /* cpy 1 b */
  b = 1;
line03: /* cpy 26 d */
  d = 26;
line04: /* jnz c 2 */
  if (c) { goto line06; }
line05: /* jnz 1 5 */
  if (1) { goto line10; }
line06: /* cpy 7 c */
  c = 7;
line07: /* inc d */
  d++;
line08: /* dec c */
  c--;
line09: /* jnz c -2 */
  if (c) { goto line07; }
line10: /* cpy a c */
  c = a;
line11: /* inc a */
  a++;
line12: /* dec b */
  b--;
line13: /* jnz b -2 */
  if (b) { goto line11; }
line14: /* cpy c b */
  b = c;
line15: /* dec d */
  d--;
line16: /* jnz d -6 */
  if (d) { goto line10; }
line17: /* cpy 16 c */
  c = 16;
line18: /* cpy 17 d */
  d = 17;
line19: /* inc a */
  a++;
line20: /* dec d */
  d--;
line21: /* jnz d -2 */
  if (d) { goto line19; }
line22: /* dec c */
  c--;
line23: /* jnz c -5 */
  if (c) { goto line18; }

  printf("a=%d b=%d c=%d d=%d\n", a, b, c, d);
  return 0;
}
