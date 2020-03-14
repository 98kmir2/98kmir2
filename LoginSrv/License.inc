asm 
  DB $EB,$06,$55,$44,$55,$03,$a8,$09;   
end;
{$IF DEBUG = 0}
  asm
    jz @@Start
    jnz @@Start
    db 0F4h
    db 0EBh
    db 004h
    db 0E8h
    @@Start:
  end;
{$IFEND}