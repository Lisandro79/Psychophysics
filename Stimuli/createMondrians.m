function ArrayOfMondrians = CreateMondrians (NumberOfMondrians, FinalSizeHeight, FinalSizeWidth )

%This function creates an array of Grayscale Mondrians. It takes as
%argument the number of Mondrians to be created.
%It returns a cell array containing in each cell a matrix with values from 0 to 255 (uint8). 
%This matrixes can be used to fill the Red channel of the images used for the CFS
%experiment, where the Green Channel is set to zero and the Blue channel is
%filled with the stimuli grayscale image.


% FinalSizeHeight= 300; %Set the final size value for the Mondrians.
% FinalSizeWidth= 300;


%Create the main Mondrian Square. Give initial Value. This is not going to
%be the final value.
Mondrian = zeros(500,500);


NumberOfLayers= 10; %How many times we are going to fill and refill each surface of the mondrian.

%If we don't want a backgound color of value "0" then we should change the
%background color of Mondria here, before starting.
% Mondrian(:,:) = 100;



%Create Colors for the rectangles or squares
% NoRed=0;
Red50=50;
Red100=100;
Red125=125;
Red150=150;
Red175=175;
Red200=200;
Red225=225;
Red250=250;
Colors= [ Red50, Red100, Red125, Red150, Red175, Red200, Red225, Red250];

%Create Dimensions for the Squares or rectangles. In pixels
ExtremeSmall= 5;
LessThanSmallest= 15;
Smallest= 25;
SmallSmall= 35;
Small= 45;
Medium= 55;
MediumMedium= 65;
% MediumAndSomeMore= 75;
% Large= 100;

Dimensions= [ExtremeSmall, LessThanSmallest, Smallest, SmallSmall, Small, Medium, MediumMedium ];

%Create the Grid on the Mondrian: The points represent the left-top border of the squares.
%This should respect the size of the minimum square or rectangle dimension.
HorizontalPoints= 1:50: (FinalSizeHeight)*2+1;
VerticalPoints= 1:50: (FinalSizeWidth)*2+1 ;
AllPositionsInMatrix= length(VerticalPoints)*length(HorizontalPoints);

%Create Matrix with all posible positions on the Mondrians (6x6 in this case)
%We do it in this case so as not to leave any part of the Mondrian
%uncovered.
for i=1:length(HorizontalPoints)
    for j=1:length(VerticalPoints)
        PositionsMatrix{i,j} = [HorizontalPoints(i) VerticalPoints(j)];%#ok
    end
end

%Fill each Mondrian with the Different layers of Squares and Rectangles.
for h=1:NumberOfMondrians

    for i=1:NumberOfLayers
        %Also Randomize Positions (though it is not absolutely necessary)
        RandomPositions = randperm(AllPositionsInMatrix);
        for j=1:AllPositionsInMatrix
            %Randomized Sizes to pick up
            RandomVerticalSize= randperm(length(Dimensions));
            RandomHorizontalSize = randperm(length(Dimensions));
            %Randomized colors to pick up
            RandomColor = randperm (length(Colors));
            %Fill the Mondrian Layer in each position with each rectangle.
            %The first line defines the vertical position of the Square or
            %rectangle and The second line defines the horizontal position of the Square or
            %rectangle.
            %For script reading clarity purposes we create this two variables.
            VertInitial= PositionsMatrix{RandomPositions(j)}(1);
            HorizInitial= PositionsMatrix{RandomPositions(j)}(2);
            Mondrian( VertInitial : VertInitial+ Dimensions(RandomHorizontalSize(1)) , ...
                HorizInitial : HorizInitial + Dimensions(RandomVerticalSize(1)) )  = Colors(RandomColor(1));

        end
        %As the matrix is going to be expanded to the right we need to
        %do a final crop to the image.
        Mondrian= uint8( Mondrian( 1:FinalSizeHeight, 1:FinalSizeWidth) );

    end
    %Fill the Array of Mondrians with each Mondrian.
    ArrayOfMondrians{h} =  Mondrian ; %#ok

end







