/*
 * FARSI/ARABIC SHAPING PREPROCESSOR FOR NEATROFF
 *
 * Copyright (C) 2010-2014 Ali Gholami Rudi <ali at rudi dot ir>
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "uc.h"
#include "util.h"

static void shape(int *s)
{
	int *c = NULL, *n = NULL;
	int cold = 0, cnew;
	while (*s) {
		if (s == n)
			s++;
		while (uc_comb(*s))
			s++;
		c = n;
		n = s;
		if (!c || !UC_R2L(*c)) {
			cold = 0;
			continue;
		}
		cnew = uc_shape(*c, cold, n ? *n : 0);
		cold = *c;
		*c = cnew;
	}
}

static void shape_ligs(int *d, int *s)
{
	int l;
	while (*s) {
		if ((l = uc_lig(d, s)))
			s += l;
		else
			*d = *s++;
		d++;
	}
	*d = 0;
}

#define MAXLEN		(1 << 23)

static char raw[MAXLEN];
static int utf8[MAXLEN];
static int ligs[MAXLEN];

int main(int argc, char *argv[])
{
	xread(0, raw, sizeof(raw));
	utf8_dec(utf8, raw);
	shape(utf8);
	shape_ligs(ligs, utf8);
	utf8_enc(raw, ligs);
	xwrite(1, raw, strlen(raw));
	return 0;
}
