function [] = visualizeGraph(graph, mat, startNode)

% open figure hold on, then call function, giving graph and mat, and
% starting node

% get the current node
thisNode = mat(str2num(startNode),:);

% plot first node (all child nodes will be plotted in calling function
if strcmp(startNode,'1')
    figure
    hold on
    %plot(thisNode(1),thisNode(2),'o')
end

% if not leaf
if outdegree(graph,startNode) > 0
    children = successors(graph,startNode);
    
    %for each child
    for i = 1:length(children)
        child = children{i};
        childNode = mat(str2num(child),:);
        %plot from current point to child point
        plot([thisNode(1),childNode(1)],[thisNode(2),childNode(2)],'Color','black')
        %plot child point
        %plot(childNode(1),childNode(2),'o');
        % recur on all children
        visualizeGraph(graph,mat,child)
    end

end

xlabel('Insertion')
ylabel('Rotation [0,60]->[0,2*Pi]')