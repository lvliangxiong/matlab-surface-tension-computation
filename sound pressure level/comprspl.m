function comprspl( varargin )
%AUDIOPROCESS plot the fft spectrum
%   COMPRSPL(varargin) plot audio waveform and relative sound
%   pressure level
%   
%   Note:
% 
%   Only applied on single channel auido file!
% 
%   Example:
%   
%   computeRSPL('audio_single_channel.wav', 1) 
% 
%   By Liangxiong Lyu
%   Update: 20180323
%------------------------------------------------------------------------------

    inparser=inputParser;
    default_samples=[1, inf];
    default_base_level= 2*10^-5;
    default_wlen= 200;
    default_inc= 80;
    addRequired(inparser, 'filename')
    addOptional(inparser, 'samples', default_samples)
    addParameter(inparser, 'base_level', default_base_level)
    addParameter(inparser, 'wlen', default_wlen)
    addParameter(inparser, 'inc', default_inc)
%     addParameter(inparser, 'base_level', default_base_level)
    parse(inparser, varargin{:})
    
    audio_filename= inparser.Results.filename;
    audio_base_level = inparser.Results.base_level;
    wlen = inparser.Results.wlen;
    inc = inparser.Results.inc;
    samples = inparser.Results.samples;
    
    info=audioinfo(audio_filename);
    num_channels=info.NumChannels;
    sample_rate=info.SampleRate;
    disp(['This audio contains ' num2str(num_channels) ' Channels' ...
        ' & Sample rate: ' num2str(sample_rate)])
    if num_channels >1
        disp(['This audio contains more than one channel'... 
            'and can not be processed by this operator!'])
        return
    end
    [y, Fs]=audioread(audio_filename,samples);
    % wlen: frame length
    % inc: frame shift
    win = hanning(wlen);
    N = length(y);
    % split frames
    Y = enframe(y,win,inc)';
    % fn: number of frames
    fn = size(Y,2);
    time = (0:N-1)/Fs;
    % initiate En: Energy & SPL: sound pressure level
    En = zeros(1,fn);
    SPL = zeros(1,fn);
    for i = 1: fn
    %     iteration over every frame
        u = Y(:,i);
    %     Compute energy of every frame
        en = u.* u;
        En(i) = sum(en)/wlen;
        SPL(i) = 20 * log10(En(i)/audio_base_level);
    end
    figure
    subplot 211; plot(time,y,'k');
    title('Waveform');
    ylabel('Magnitude'); xlabel('Time/s');

    frameTime=frame2time(fn,wlen,inc,Fs);
    subplot 212; plot(frameTime,SPL,'k');
    title('SPL');
    ylabel('SPL/dB'); xlabel('Time/s');
   
end

