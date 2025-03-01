c$Id:$
      subroutine pnumna(ix,nen1,nen,numel, ip)

c      * * F E A P * * A Finite Element Analysis Program

c....  Copyright (c) 1984-2009: Robert L. Taylor
c                               All rights reserved

      implicit  none

      include  'pbody.h'

      integer   nen1,nen, numel, i,nn
      integer   ix(nen1,*), ip(*)

      save

c     Tag active nodes

      do nn = 1,numel
        if(ix(nen1-1,nn).ge.0 .and.
     &    (maplt.eq.0 .or. ix(nen1,nn).eq.maplt)) then
          do i = 1,nen
            if(ix(i,nn).gt.0) ip(ix(i,nn)) = 1
          end do
        endif
      end do

      end
