#include <unistd.h>
#include "util.h"

int xread(int fd, void *buf, int len)
{
	int n = 0;
	int r;
	while ((r = read(fd, buf + n, len - n)) > 0)
		n += r;
	return n;
}

int xwrite(int fd, void *buf, int len)
{
	int n = 0;
	int w;
	while ((w = write(fd, buf + n, len - n)) > 0)
		n += w;
	return n;
}

static int readutf8(char **src)
{
	int result;
	int l = 1;
	char *s = *src;
	while (l < 6 && (unsigned char) *s & (0x40 >> l))
		l++;
	result = (0x3f >> l) & (unsigned char) *s++;
	while (l--)
		result = (result << 6) | ((unsigned char) *s++ & 0x3f);
	*src = s;
	return result;
}

void utf8_dec(int *dst, char *src)
{
	char *s = src;
	int *d = dst;
	while (*s) {
		if (!(~(unsigned char) *s & 0xc0))
			*d++ = readutf8(&s);
		else
			*d++ = *s++;
	}
	*d = '\0';
}

static void writeutf8(char **dst, int c)
{
	char *d = *dst;
	int l = 0;
	if (c > 0xffff) {
		*d++ = 0xf0 | (c >> 18);
		l = 3;
	} else if (c > 0x7ff) {
		*d++ = 0xe0 | (c >> 12);
		l = 2;
	} else if (c > 0x7f) {
		*d++ = 0xc0 | (c >> 6);
		l = 1;
	}
	while (l--)
		*d++ = 0x80 | (c >> (l * 6)) & 0x3f;
	*dst = d;
}

void utf8_enc(char *dst, int *src)
{
	int *s = src;
	char *d = dst;
	while (*s) {
		if (*s & ~0x7f)
			writeutf8(&d, *s++);
		else
			*d++ = *s++;
	}
	*d = '\0';
}
