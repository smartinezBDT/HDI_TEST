     H DFTACTGRP(*NO)
     FQSYSPRT   O    F  132        PRINTER
     D PrintMe         ds                  qualified
     D name                          21a
     D data                         111a

     D XML_Event_Name  PR            20A   varying
     D event                         10i 0 value

     D xmlHandler      PR            10i 0
     D ignore                         1a
     D event                         10i 0 value
     D string                          *
     D stringLen                     20i 0 value
     D exceptionId                   10i 0 value

     D XML             s            500a   varying
     D ignoreMe        s              1a
         /free
           XML = '<xmlTest>+
           <name type="author">Sergio Fernandez</name>+
           </xmlTest>';
           xml-sax %handler(xmlHandler: ignoreMe)
           %XML(XML: 'doc=string');
           *inlr = *on;
         /end-free
     P xmlHandler      B
     D xmlHandler      PI            10i 0
     D ignore                         1a
     D event                         10i 0 value
     D string                          *   value
     D stringLen                     20i 0 value
     D exceptionId                   10i 0 value

     D value           s          65535a   based(String)
     D ucs2val         s          16363c   based(String)
     D dspstr          s             52a
         /free
              PrintMe.name = XML_Event_Name(event);
              PrintMe.data = *blanks;
              select;
              when string=*null or stringlen<1;
              // Tag vacío...
              when stringlen>%size(value);
              PrintMe.data = '** Long String Invalida';
              other;
              PrintMe.data = %subst(value:1:stringlen);
              endsl;
              write QSYSPRT PrintMe;
              return 0;
         /end-free
     P                 E


     P XML_Event_Name  B
     D XML_Event_Name  PI            20A   varying
     D event                         10i 0 value
         /free
          select;
          when event = *XML_START_DOCUMENT;
          return 'XML_START_DOCUMENT';
          when event = *XML_VERSION_INFO;
          return 'XML_VERSION_INFO';
          when event = *XML_ENCODING_DECL;
          return 'XML_ENCODING_DECL';
          when event = *XML_STANDALONE_DECL;
          return 'XML_STANDALONE_DECL';
          when event = *XML_DOCTYPE_DECL;
          return 'XML_DOCTYPE_DECL';
          when event = *XML_START_ELEMENT;
          return 'XML_START_ELEMENT';
          when event = *XML_CHARS;
          return 'XML_CHARS';
          when event = *XML_PREDEF_REF;
          return 'XML_PREDEF_REF';
          when event = *XML_UCS2_REF;
          return 'XML_UCS2_REF';
          when event = *XML_UNKNOWN_REF;
          return 'XML_UNKNOWN_REF';
          when event = *XML_END_ELEMENT;
          return 'XML_END_ELEMENT';
          when event = *XML_ATTR_NAME;
          return 'XML_ATTR_NAME';
          when event = *XML_ATTR_CHARS;
          return 'XML_ATTR_CHARS';
          when event = *XML_ATTR_PREDEF_REF;
          return 'XML_ATTR_PREDEF_REF';
          when event = *XML_ATTR_UCS2_REF;
          return 'XML_ATTR_UCS2_REF';
          when event = *XML_UNKNOWN_ATTR_REF;
          return 'XML_UNKNOWN_ATTR_REF';
          when event = *XML_END_ATTR;
          return 'XML_END_ATTR';
          when event = *XML_PI_TARGET;
          return 'XML_PI_TARGET';
          when event = *XML_PI_DATA;
          return 'XML_PI_DATA';
          when event = *XML_START_CDATA;
          return 'XML_START_CDATA';
          when event = *XML_END_CDATA;
          return 'XML_END_CDATA';
          when event = *XML_COMMENT;
          return 'XML_COMMENT';
          when event = *XML_EXCEPTION;
          return 'XML_EXCEPTION';
          when event = *XML_END_DOCUMENT;
          return 'XML_END_DOCUMENT';
          other;
          return 'UNKNOWN EVENT';
          endsl;
         /end-free
     P                 E

