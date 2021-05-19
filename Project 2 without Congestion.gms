Set
    V Node /Solna, Nacka, Sollentuna, Taby, Sodermalm, Huddinge, Centrum/;

Alias(V,I,J,K,L);


Sets
    ii(I,I) diagonal elements / #V:#V /
    ij(i,i) all elements / #i.#i /
    ij_wo_ii(i,i);
    
ij_wo_ii(i,j) = ij(i,j) - ii(i,j);

Alias(V,I,J,K,L);

    
Table T(V,V) Time it takes to take road
            Solna   Nacka   Sollentuna  Taby    Sodermalm   Huddinge    Centrum
Solna       0       100        13      12         100         100          6  
Nacka       100     0          100     100        15          23           100
Sollentuna  13      100        0       14         100         100          100
Taby        12      100        14      0          100         100          15
Sodermalm   100     15         100     100        0           100          3
Huddinge    100     23         100     100        13          0            15
Centrum     6       100        100     15         3           15           0;

Parameter Population(V) Population of suburb
    /Solna 82
    Nacka 105
    Sollentuna  74
    Taby    65
    Sodermalm   130
    Huddinge    113
    Centrum 347/;
    
Parameter GDPShare(V) Share of GDP
    /Solna  0.10
    Nacka   0.05
    Sollentuna  0.05
    Taby    0.05
    Sodermalm   0.20
    Huddinge    0.05
    Centrum 0.50/;

Parameter Travelers(V,V) Number of travelers from I to J;

loop(I, 
    loop(J,
            Travelers(I,J) = Population(I) * GDPShare(J);
      );
);

Travelers('Solna', 'Solna') = 0;
Travelers('Nacka', 'Nacka') = 0;
Travelers('Sollentuna', 'Sollentuna') = 0;
Travelers('Taby', 'Taby') = 0;
Travelers('Sodermalm', 'Sodermalm') = 0;
Travelers('Huddinge', 'Huddinge') = 0;    
Travelers('Centrum', 'Centrum') = 0;

Parameters
    StartingInput(I,J,V)
    EndingOutput(I,J,V);

*Creates vectors that are 0 except if the node is a starting or ending node.      
loop(I,
    loop(J,          
        loop(V, 
            if(SameAs(I,V),
                StartingInput(I,J,V) = Travelers(I,J);
            else
                StartingInput(I,J,V) = 0;);
            if(SameAs(J,V),
                EndingOutput(I,J,V) = Travelers(I,J);
            else
                EndingOutput(I,J,V) = 0;););););



Variable Z Sum of travelling time;

Positive Variable
    X(I,J,K,L) Number of cars that want to go from I to J that are on road between K and L
    Y(K,L) Total number of cars on road between K and L;

Equations obj
    balance(I,J,V)
    roadusage(K,L);

obj.. Z =E= SUM((I,J,K,L), T(K,L) * X(I,J,K,L));

balance(I,J,V).. SUM(K, X(I,J,K,V)) + StartingInput(I,J,V) =E= SUM(L, X(I,J,V,L)) + EndingOutput(I,J,V);


roadusage(K,L).. Y(K,L) =E= SUM((I,J), X(I,J,K,L));

Model Traffic /ALL/;

Solve Traffic using NLP minimizing Z;

Display Y.L;




    
