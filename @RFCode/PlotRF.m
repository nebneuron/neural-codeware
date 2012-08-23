function PlotRF(this)
    figure();
    hold on;

    for i = 1 : size(this.Centers, 1)
        Utils.PlotCircle(this.Centers(i, :), this.Radii(i), 100);
    end

    hold off;
    axis equal;
    axis([0, 1, 0, 1]);
end