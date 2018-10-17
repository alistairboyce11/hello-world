      dimension amap(360,180)
      real*4 lon,lat

      open(8,file='eurocrs.map')
      open(9,file='eurocrs.gmt')
      read(8,*)((amap(i,j),i=1,360),j=1,180)
      do 20 j=1,180
         lat=90.-((j-1)+0.5)
         do 20 i=1,360
            lon=-180.+(i-1)+0.5
            write(9,*)lon,lat,amap(i,j)
 20   continue 
      end  
