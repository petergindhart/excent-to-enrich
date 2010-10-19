-- update feature that allows access to meetings (was '375CA1CA-D0E1-4768-A84E-680BBBC2D7E5' -- Programs.General)
-- in order to restrict access to ExoWeb pages
update PrgItemType
set FeatureID = '426D5613-B398-4556-BF3F-765040E5617F' -- Programs.SpecEd
where ID = 'B1B9173E-C987-4752-82DE-D7237A2BC060' -- Meeting