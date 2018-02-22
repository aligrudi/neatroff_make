/* soin: inline troff .so requests */
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>

#define LNLEN		2048

static int soin(char *path);

static int soin_cmd(char *s)
{
	char path[LNLEN];
	char *d = path;
	if (s[0] != '.' || s[1] != 's' || s[2] != 'o' || s[3] != ' ')
		return 1;
	s += 3;
	while (isspace((unsigned char) *s))
		s++;
	if (s[0] == '"') {
		s++;
		while (*s && *s != '\n' && *s != '"')
			*d++ = *s++;
	} else {
		while (*s && *s != ' ' && *s != '\n')
			*d++ = *s++;
	}
	*d = '\0';
	return soin(path);
}

static int soin(char *path)
{
	FILE *fp = path ? fopen(path, "r") : stdin;
	int lineno = 1;
	char ln[LNLEN];
	if (!fp) {
		fprintf(stderr, "soin: cannot open <%s>\n", path);
		return 1;
	}
	printf(".lf %d %s\n", lineno, path ? path : "stdin");
	while (fgets(ln, sizeof(ln), fp)) {
		lineno++;
		if (!soin_cmd(ln))
			printf(".lf %d %s\n", lineno, path ? path : "stdin");
		else
			fputs(ln, stdout);
		if (ln[0] == '.' && ln[1] == 'l' && ln[2] == 'f')
			sscanf(ln, ".lf %d", &lineno);
	}
	if (path)
		fclose(fp);
	return 0;
}

int main(void)
{
	soin(NULL);
	return 0;
}
