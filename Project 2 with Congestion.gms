Set
    V Node /Solna, Nacka, Sollentuna, Taby, Sodermalm, Huddinge, Centrum/;

Alias(V,I,J,K,L);


Sets
    ii(I,I) diagonal elements / #V:#V /
    ij(i,i) all elements / #i.#i /
    ij_wo_ii(i,i);
    
ij_wo_ii(i,j) = ij(i,j) - ii(i,j);

Alias(V,I,J,K,L);


Parameter T(K,L) Time it takes to take road
    /Solna  .Sollentuna     13
    Solna   .Taby           12
    Solna   .Centrum        6
    Nacka   .Sodermalm      15
    Nacka   .Huddinge       23
    Sollentuna  .Solna      13
    Sollentuna  .Taby       14
    Taby    .Solna          12
    Taby    .Sollentuna     14
    Taby    .Centrum        15
    Sodermalm   .Nacka      15
    Sodermalm   .Huddinge   13
    Sodermalm   .Centrum    3
    Huddinge    .Nacka      23
    Huddinge    .Sodermalm  13
    Huddinge    .Centrum    15
    Centrum .Solna          6
    Centrum .Taby           15
    Centrum .Sodermalm      3
    Centrum .Huddinge       15/;

    
Parameter U(K,L) Capacity of each road
    /Solna  .Sollentuna     180
    Solna   .Taby           100
    Solna   .Centrum        270
    Nacka   .Sodermalm      200
    Nacka   .Huddinge       200
    Sollentuna  .Solna      180
    Sollentuna  .Taby       160
    Taby    .Solna          100
    Taby    .Sollentuna     160
    Taby    .Centrum        170
    Sodermalm   .Nacka      200
    Sodermalm   .Huddinge   160
    Sodermalm   .Centrum    220
    Huddinge    .Nacka      200
    Huddinge    .Sodermalm  160
    Huddinge    .Centrum    270
    Centrum .Solna          270
    Centrum .Taby           170
    Centrum .Sodermalm      220
    Centrum .Huddinge       270/;
    
Parameter a(K,L) Constant for traffic congestion equation
    /Solna  .Sollentuna     4
    Solna   .Taby           4
    Solna   .Centrum        5
    Nacka   .Sodermalm      5
    Nacka   .Huddinge       4
    Sollentuna  .Solna      4
    Sollentuna  .Taby       4
    Taby    .Solna          4
    Taby    .Sollentuna     4
    Taby    .Centrum        4
    Sodermalm   .Nacka      5
    Sodermalm   .Huddinge   4
    Sodermalm   .Centrum    6
    Huddinge    .Nacka      4
    Huddinge    .Sodermalm  4
    Huddinge    .Centrum    4
    Centrum .Solna          5
    Centrum .Taby           4
    Centrum .Sodermalm      6
    Centrum .Huddinge       4/;
    
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
    roadusage(K,L)
    roadlimit(K,L);



obj.. Z =E= SUM((K,L)$T(K,L), (T(K,L) + a(K,L) * Y(K,L) /(U(K,L) - Y(K,L))) * Y(K,L));

balance(I,J,V).. SUM(K, X(I,J,K,V)) + StartingInput(I,J,V) =E= SUM(L, X(I,J,V,L)) + EndingOutput(I,J,V);

roadlimit(K,L).. Y(K,L) =L= U(K,L);

roadusage(K,L).. Y(K,L) =E= SUM((I,J), X(I,J,K,L));

Model Traffic /ALL/;

Solve Traffic using NLP minimizing Z;

Display Y.L;



    
