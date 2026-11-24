[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "holidaydatacontainer_DataDestination", IsNewTarget = true], Settings = [Kind = "Automatic", TypeSettings = [Kind = "Table"]]]}]
shared holidaydatacontainer = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = WorkspaceId]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = LakehouseId]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "holidaydatacontainer", ItemKind = "Table"]}[Data],
  #"Filtered rows" = Table.SelectRows(#"Navigation 2", each [countryOrRegion] = Region)
in
  #"Filtered rows";
shared WorkspaceId = let
    Source = Variable.ValueOrDefault("$(/**/dataflow-Variables/WorkspaceId)", "7ccf0d7a-65f9-4a39-a9d9-6ec1889f65e0")
in
    Source;
shared LakehouseId = let
    Source = Variable.ValueOrDefault("$(/**/dataflow-Variables/LakehouseId)", "2afda249-a46c-41ef-8276-6b51a8ccaa27")
in
    Source;
shared Region = let
    Source = Variable.ValueOrDefault("$(/**/dataflow-Variables/Region)", "Sweden")
in
    Source;
shared holidaydatacontainer_DataDestination = let
  Pattern = Fabric.Warehouse([HierarchicalNavigation = true, CreateNavigationProperties = false]),
  Navigation_1 = Pattern{[workspaceId = "."]}[Data],
  Navigation_2 = Navigation_1{[displayName = "dataFactory_warehouse"]}[Data],
  Navigation_3 = Navigation_2{[Schema = "dbo"]}[Data],
  TableNavigation = Navigation_3{[Name = "holidaydatacontainer"]}?[Data]?
in
  TableNavigation;
