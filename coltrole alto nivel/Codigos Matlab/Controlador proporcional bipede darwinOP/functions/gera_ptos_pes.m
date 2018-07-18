function [ trajetoria_pe_esq, trajetoria_pe_dir ] = gera_ptos_pes(numero_trajetoria)
%GERA_PTOS_PES fucao auxiliar para juntar toda a geracao de trajetoria dos
%2 pes, lembrando que cada trajetoria eh uma matriz 3xn onde cada coluna é
%um ponto [x; y; z], nao é calculada a fibula nem o dedao, somente o ponto
%do pe

if(nargin == 0)
    numero_trajetoria = 0;
end

if(numero_trajetoria == 0)
    res = 0.1;
    g = gaussmf((res-5):res:5,[2 0])*3; 
    
    xd = [(res-5):res:5, (5-res):-res:-5, (res-5):res:5, (5-res):-res:-5];
    zr = zeros([1, length(g)]);
    zd = [g, zr, g zr]-16;
    yd = zeros(1, length(xd));
    
    xe = circshift(xd,[0, length(g)]);
    ye = circshift(yd,[0, length(g)]);
    ze = circshift(zd,[0, length(g)]);
end

if(numero_trajetoria == 1)
   xdrepete = [4:-0.32:0         zeros(1,11)       0:-0.32:-4        ];%
   ydrepete = [-3:0.5:3          repmat(3,1,11)    3:-0.5:-3         ];%
   zdrepete = [repmat(-10,1,13)  repmat(-10,1,11)  repmat(-10,1,13)  ];%
   
   xdrepete = [xdrepete  -4:0.8:4               ];
   ydrepete = [ydrepete  repmat(-3,1,11)        ];
   zdrepete = [zdrepete  -((-2:0.4:2).^2)./2-8  ];
   
   xd = [zeros(1,5)    zeros(1,6)        0:0.4:4                xdrepete xdrepete xdrepete xdrepete];%
   yd = [zeros(1,5)    0:-3/5:-3         repmat(-3,1,11)        ydrepete ydrepete ydrepete ydrepete];%
   zd = [-12:0.5:-10   repmat(-10,1,6)   -((-2:0.4:2).^2)./2-8  zdrepete zdrepete zdrepete zdrepete];%
  
   
   xerepete = [0:-0.32:-4        -4:0.8:4               4:-0.32:0        ];%
   yerepete = [-3:0.5:3          repmat(3,1,11)         3:-0.5:-3        ];%
   zerepete = [repmat(-10,1,13)  -((-2:0.4:2).^2)./2-8  repmat(-10,1,13) ];% 
   
   xerepete = [xerepete  zeros(1,11)       ];
   yerepete = [yerepete  repmat(-3,1,11)   ];
   zerepete = [zerepete  repmat(-10,1,11)  ];
   
   xe = [zeros(1,5)   zeros(1,6)       zeros(1,11)       xerepete xerepete xerepete xerepete];%
   ye = [zeros(1,5)   0:-3/5:-3        repmat(-3,1,11)   yerepete yerepete yerepete yerepete];%
   ze = [-12:0.5:-10  repmat(-10,1,6)  repmat(-10,1,11)  zerepete zerepete zerepete zerepete];% 
   
end
    trajetoria_pe_dir = [xd; yd; zd];
    trajetoria_pe_esq = [xe; ye; ze];
end

