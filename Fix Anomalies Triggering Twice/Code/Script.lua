local orig_SubsurfaceAnomaly_ScanCompleted = SubsurfaceAnomaly.ScanCompleted
function SubsurfaceAnomaly:ScanCompleted(scanner)
    local tech_action = self.tech_action
    if tech_action then
        self.sequence = ""
    end
    orig_SubsurfaceAnomaly_ScanCompleted(self, scanner)
end
