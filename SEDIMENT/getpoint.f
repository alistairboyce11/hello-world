      character*80 line  
      common/amapx/amap(360,180)
      
      call getmap

 1    continue
      print*,'enter longitude and latitude in deg'  
      read(*,'(a)')line 
      if(line(1:1).eq.' ')stop
      read(line,*,err=99)flon,flat
      call getval(flon,flat,eval)
      print*,flon,flat,': ',eval
      goto 1
 99   stop
      end

      subroutine getmap
      character*80 filen 
      common/amapx/amap(360,180)

 1    print*,'enter map file name'
      read(*,'(a)')filen
      open(9,file=filen,status='old',iostat=iret)
      if(iret.ne.0)goto 1

      read(9,101) ((amap(j,i),j=1,360),i=1,180)
      close(9)
 101  format(15f7.3)
      return
      end

      subroutine getval(flon,flat,eval)
      common/amapx/amap(360,180)
      fcl=90.-flat
      fln=flon+180.
      if(fln.gt.360.)fln=fln-180.
      icol=nint(fcl+0.5)
      ilon=nint(fln+0.5)
      eval=amap(ilon,icol)
      return
      end
