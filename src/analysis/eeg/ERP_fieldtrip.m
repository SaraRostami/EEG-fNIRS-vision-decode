%% load preprocessed .set file from EEGLAB to FieldTrip
filename = 'C:\SaraDrive\Work\M.Sc_UWO\Thesis\Pilot1_2025-11-17\EEG\pipeline1(mine)\Triggerfixed_pipeline\session1_trigfix_ds_lp_vr_ref_ica_icrej_hp01_ep_bc_chrej_nf_intpol_trej.set'; 
cfg = []; 
cfg.dataset = filename;
hdr = ft_read_header(filename);
event = ft_read_event(filename);
ft_data1 = ft_preprocessing(cfg);
ft_data1.hdr = hdr;
%% remove the ear channels
% cfg = [];
% cfg.channel = union(ft_data1.elec.label(1:62),ft_data1.elec.label(65:128));
% ft_data1 = ft_selectdata(cfg, ft_data1);
%% Visualize time series data
% input configurations

cfg= [];
cfg.lim = 'maxmin';
cfg.viewmode = 'vertical'; %'butterfly';
cfg.comscaple = 'local';
cfg.markersymbol = '.';
cfg.markersize = 5;
cfg.linewidth = 1;
cfg.markercolor = [0 0.69 0.94];

% cfg.trl = "mmf"; %which trial to display
cfg.interactive = 'yes';
cfg.channel = 'EEG';
cfg.blocksize = 0.8; % length of data to display in seconds

ft_databrowser(cfg, ft_data1);
%% Extracting Conditions
cfg = [];
% cfg.trials = find(ft_data1.trialinfo==1);
vis_all = ft_timelockanalysis(cfg, ft_data1);
%%
cfg = [];
% cfg.layout = 'mpi_customized_acticap64.mat';
cfg.interactive = 'yes';
cfg.showoutline = 'yes';
ft_multiplotER(cfg, vis_all)

%% Topoplots of ERPs

ft_data1.elec.coordsys = 'eeglab';
cfg = [];
cfg.elec = ft_data1.elec;   
layout = ft_prepare_layout(cfg);

cfg              = [];
cfg.layout       = layout;
cfg.xlim         = [0.2 0.6]; % seconds
cfg.zlim         = [-3 5]; % Volts
cfg.colorbar     = 'yes';
cfg.colorbartext =  'Electric Potential (uV)';

ft_topoplotER(cfg, vis_all);
title('Evoked Response: All Visual Stimuli')
% print -dpng standard_aud.png

% figure
% ft_topoplotER(cfg, house);
% title('Evoked Response: House')
% print -dpng deviant_aud.png

%% Visualize ERPs (Expectation Face)

cfg         = [];
% cfg.channel = {'O1'};% , 'O2', 'Oz', 'POz', 'PO7', 'PO3', 'PO8', 'PO4', 'P3', 'P2', 'Pz'};
cfg.channel = sig_chnls;
cfg.xlim = [-0.2 0.6];
% cfg.ylim    = [-3 5]; % Volts

figure
% ft_singleplotER(cfg, erp_expected_f,erp_unexpected_f);
ft_singleplotER(cfg, shuffled_faces,shuffled_houses);

hold on
xlabel('Time (s)')
ylabel('Electric Potential (uV)')
title(sprintf('Face vs. House (pseudo-trials of 10) - channel(s): %s', 'All Channels'))%cfg.channel{:}
xline(0, 'k--')
yline(0, 'k--')
% legend({'Expected', 'Unexpected'})
legend({'Face', 'House'})


print -dpng singleplot.png
