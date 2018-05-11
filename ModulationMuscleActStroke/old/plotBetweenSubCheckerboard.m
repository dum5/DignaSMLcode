% function [fh,ph]=plotBetweenSubCheckerboard(this,fh,ph)
%            if nargin<2
%                fh=figure();
%            else
%                figure(fh);
%            end
%            if nargin<3
%                ph=gca;
%            else
%                axes(ph);
%            end
%            m=this.mean;
%            imagesc(m.Data')
%            ax=gca;
%            ax.YTick=1:length(this.labels);
%            ax.YTickLabels=this.labels;
%            ax.XTick=[1 1+cumsum(this.alignmentVector)]-.5;
%            ax.XTickLabel=this.alignmentLabels;
%            %Colormap:
%             ex2=[0.2314    0.2980    0.7529];
%             ex1=[0.7255    0.0863    0.1608];
%             gamma=.5;
%             map=[bsxfun(@plus,ex1.^(1/gamma),bsxfun(@times,1-ex1.^(1/gamma),[0:.01:1]'));bsxfun(@plus,ex2.^(1/gamma),bsxfun(@times,1-ex2.^(1/gamma),[1:-.01:0]'))].^gamma;
% 
%             colormap(flipud(map))
%             caxis([-1 1]*max(abs(m.Data(:))))
%             colorbar
%             
%             %To do: check if the events exist, and add DS/STANCE/DS/SWING labels
%         end

dataEdif1=nanmedian(dataEc1,4)-nanmedian(dataEs1,4);Np=30;
evLabel={'iHS','','cTO','','','','cHS','','iTO','','',''};
                ATS=alignedTimeSeries(0,1,dataEdif1(:,:,1),labelPrefix,ones(1,12),evLabel);
%                 if flipLR
%                     [ATS,iC]=ATS.flipLR;
%                 end
                ATS.plotCheckerboard();
                %axes(ph(i))