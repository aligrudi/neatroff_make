#define UC_R2L(ch)		(((ch) & 0xff00) == 0x0600 || ((ch) & 0xfffc) == 0x200c || ((ch) & 0xff00) == 0xfb00 || ((ch) & 0xff00) == 0xfc00)

int uc_shape(int cur, int prev, int next);
int uc_lig(int *dst, int *src);
int uc_comb(int c);
