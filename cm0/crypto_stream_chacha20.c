/* Based on the public domain implemntation in
 * crypto_stream/chacha20/e/ref from http://bench.cr.yp.to/supercop.html
 * by Daniel J. Bernstein */

#include <stdint.h>
#include "crypto_stream_chacha20.h"


static const unsigned char sigma[16] = "expand 32-byte k";

int crypto_stream_chacha20(unsigned char *c,unsigned long long clen, const unsigned char *n, const unsigned char *k)
{
  unsigned char in[16];
  unsigned char block[64];
  unsigned char kcopy[32];
  unsigned long long i;
  unsigned int u;

  if (!clen) return 0;

  for (i = 0;i < 32;++i) kcopy[i] = k[i];
asm_csc_for(in,n);

  while (clen >= 64) {
    asm_crypto_core(c,kcopy,in);

    u = 1;
    for (i = 8;i < 16;++i) {
      u += (unsigned int) in[i];
      in[i] = u;
      u >>= 8;
    }

    clen -= 64;
    c += 64;
  }

  if (clen) {
    asm_crypto_core(block,kcopy,in);
    for (i = 0;i < clen;++i) c[i] = block[i];
  }
  return 0;
}



