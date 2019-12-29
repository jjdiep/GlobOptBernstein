%% description
% This script plots the number of Bernstein patches (i.e., the length of
% the list) versus the number of iterations of PCBA for each of the 8
% benchmark problems.
%
% Author: Shreyas Kousik
% Created: 28 Dec 2019
% Updated: -
%
%% user parameters
% which problem to plot
problem_index = 4 ;

% whether or not to save the output
save_pdf_flag = true ;

%% automated from here
% load data
load(['P',num2str(problem_index),'_time_and_memory_info.mat'])

%% process data
% get the problem dimension and degree in each dimension ;
dimension = size(bernstein_cost,1) - 1 ;
degrees = max([bernstein_cost(1:dimension,:),bernstein_constraint(1:dimension,:)],[],2) ;

% relabel the "bernstein memory" variable
bernstein_N_patches = bernstein_memory ;

% (over)approximate the memory used
memory_per_patch = prod(degrees + 1) * 4 ; % 4 bytes per float (single)
bernstein_memory = memory_per_patch.*bernstein_N_patches./1024 ; % in kilobytes

% get the number of iterations (each entry in bernstein_memory is the
% number of patches either from subdivision or elimination, and subdivision
% happens once along each dimension in each iteration, so the denominator
% is 2*d; the first "0" entry in bernstein_memory marks the iteration
% where the problem was solved to the specified tolerances)
problem_solved_index = find(bernstein_N_patches == 0,1,'first') + 1 ;
num_iter = (problem_solved_index) / (2*dimension) ;

% get indices for all steps
all_indices = 1:problem_solved_index ;

% get the indices where elimination occurred
elim_indices = 2:2:problem_solved_index ;

% get the indices where subdivision occurred
subd_indices = all_indices ;
subd_indices(elim_indices) = [] ;

% get x values for plotting the number of iterations
plot_subd_values = subd_indices ./ (2*dimension) ;
plot_elim_values = elim_indices ./ (2*dimension) ;

%% plot
close all ; 
f1 = figure(1) ; clf ; hold on ;

% plot the number of patches at every subdivision step
h_subd = plot(plot_subd_values,bernstein_N_patches(subd_indices),'b.','MarkerSize',12) ;

% plot the number of patches at each elimination step
h_elim = plot(plot_elim_values,bernstein_N_patches(elim_indices),'r.','MarkerSize',12) ;

% label left side
ylabel('Number of Patches')

% add x ticks for every iteration
grid on
xticks(1:2:num_iter)
xtickangle(45)

% get the yticks
yt_left = yticks ;

% plot memory usage on right
yyaxis right
% set(gca,'LineColor','k')
y_left_max = max(yt_left)*memory_per_patch./1024 ;
h_mem = plot([0 1],[0,y_left_max],'LineStyle', 'none') ; % invisible plop
ylabel('Approximate Memory Used [kB]')
set(gca,'Color','none')

% add legend
legend([h_subd h_elim],'Subdivision','Elimination')

% label plot
xlabel('Iteration')
set(gca,'FontSize',14)

% set plot size
set(gcf,'Position',[1000 800 600 400])

%% save figure
if save_pdf_flag
    % size the figure correctly
    set(f1,'Units','Inches');
    pos = get(f1,'Position');
    set(f1,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    
    % print
    print(f1,['P',num2str(problem_index),'_patches_vs_iterations.pdf'],'-dpdf','-r0')
end
