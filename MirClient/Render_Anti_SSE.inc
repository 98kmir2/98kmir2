movdqa  xmm0, xmm6 
psrlw   xmm0, $0B 
psllw   xmm0, $0B 
movdqa  xmm1, xmm7 
psrlw   xmm1, $0B 
psllw   xmm1, $0B 
pcmpeqw xmm2, xmm2 
psubw   xmm2, xmm0
pmulhuw xmm2, xmm1
paddusw xmm2, xmm0
paddusw xmm2, xmm4 
psrlw   xmm2, $0B 
psllw   xmm2, $0B 
movdqa  xmm0, xmm6 
psrlw   xmm0, $05 
psllw   xmm0, $0A 
movdqa  xmm1, xmm7 
psrlw   xmm1, $05 
psllw   xmm1, $0A 
pcmpeqw xmm3, xmm3 
psubw   xmm3, xmm0 
pmulhuw xmm3, xmm1
paddusw xmm3, xmm0
paddusw xmm3, xmm4 
psrlw   xmm3, $0A 
psllw   xmm3, $05 
por     xmm2, xmm3 
movdqa  xmm0, xmm6 
psllw   xmm0, $0B 
movdqa  xmm1, xmm7 
psllw   xmm1, $0B 
pcmpeqw xmm3, xmm3 
psubw   xmm3, xmm0 
pmulhuw xmm3, xmm1
paddusw xmm3, xmm0
paddusw xmm3, xmm4 
psrlw   xmm3, $0B 
por     xmm2, xmm3 