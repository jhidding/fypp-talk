
program hello
    implicit none

    print *, 'Hello, World!'
    
    #:if defined('universal')
    print *, 'Hello, Universe!'
    #:endif

    #:if defined('garbage')
    garbage
    #:endif

    #:if defined('local-ifs')

    #:endif
end program hello

! vim:sw=4:ts=4
