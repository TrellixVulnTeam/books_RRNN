c$Id:$
      subroutine ckbrk8 ( n, ix, xl, ndm, nel, shp )

c      * * F E A P * * A Finite Element Analysis Program

c....  Copyright (c) 1984-2009: Robert L. Taylor
c                               All rights reserved

c-----[--.----+----.----+----.-----------------------------------------]
c      Purpose: Check 8-node brick for bad data.
c               Write message to file on errors located.

c      Inputs:
c         n         - Number of element being checked
c         ix(*)     - List of nodes for element
c         xl(ndm,*) - Coordinate array
c         ndm       - Spatial dimension of mesh
c         nel       - Number of nodes on element

c      Outputs:
c         None

c      Scratch:
c         shp(*)    - Array to store shape functions
c-----[--.----+----.----+----.-----------------------------------------]
      implicit  none

      include  'fdata.h'
      include  'iofile.h'
      include  'pointer.h'
      include  'comblk.h'

      integer   ndm, nel, i, l, n, ineg
      integer   ndty
      real*8    detj

      integer   ix(*)
      integer   ic(16)
      real*8    rst(3,8), xl(ndm,*), shp(*)

      save

      data      rst/-1.d0,-1.d0,-1.d0,   1.d0,-1.d0,-1.d0,
     &               1.d0, 1.d0,-1.d0,  -1.d0, 1.d0,-1.d0,
     &              -1.d0,-1.d0, 1.d0,   1.d0,-1.d0, 1.d0,
     &               1.d0, 1.d0, 1.d0,  -1.d0, 1.d0, 1.d0/

c     Check element for input errors

      ndty = np(49) - 1
      ineg = 0
      do l = 1,nel
        if(ix(l).gt.0) then
          if(mr(ndty+ix(l)).lt.0) then
            ic(ineg+1) = l
            ic(ineg+2) = abs(ix(l))
            ineg = ineg + 2
          endif
        endif
      end do

c     Node numbering errors

      if(ineg.gt.0) then
        write(iow,2000) n,(ic(i),i=1,ineg)
        if(ior.lt.0) write(*,2000) n,(ic(i),i=1,ineg)

c     Compute jacobian at each corner of element

      else
        do l = 1,nel
          call bjac3d ( rst(1,l) , xl, ndm, shp, detj )
          if(detj.le.0.0d0) then
            ic(ineg+1) = l
            ic(ineg+2) = abs(ix(l))
            ineg = ineg + 2
          endif
        end do
        if(ineg.gt.0 .and. pfr) then
          write(iow,2001) n,(ic(i),i=1,ineg)
          if(ior.lt.0) write(*,2001) n,(ic(i),i=1,ineg)
        endif
        if(nel.eq.8 .and. ineg.eq.2*nel) then
          do l = 1,4
            ineg    = ix(l)
            ix(l  ) = ix(l+4)
            ix(l+4) = ineg
          end do
        end if
      endif

2000  format(' >Element',i4,' coordinates not input for nodes:'/
     &      ('                Local =',i3,' Global =',i4))

2001  format(' >Element',i4,' has negative jacobian at nodes:'/
     &      ('                Local =',i3,' Global =',i4))

      end
