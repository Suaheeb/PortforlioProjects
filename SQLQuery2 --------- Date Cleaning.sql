---This is a project about data cleaning in SQL

--Changing The Date Format

Select *
from NashvilleHousing

ALTER TABLE Nashvillehousing
Add New_SaleDate date;

update NashvilleHousing
set new_SaleDate = CONVERT(date,SaleDate)


Select new_SaleDate, CONVERT(date,SaleDate)
from NashvilleHousing


--Populating The Property Address

select a.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress,
ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

select PropertyAddress
from NashvilleHousing
where PropertyAddress is null


--Separating the Address into individual column(Address,City,States)

Select PropertyAddress
From NashvilleHousing

select 
SUBSTRING(PropertyAddress,1, CHARINDEX(',' , PropertyAddress) -1)as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 ,
LEN(PropertyAddress)) as address
from NashvilleHousing


Alter table nashvilleHousing
Add PropertyRealAddress nvarchar(255);

update NashvilleHousing
set PropertyRealAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',' , PropertyAddress) -1)


Alter table nashvilleHousing
Add PropertyCityAddress nvarchar(255);

update NashvilleHousing
set PropertyCityAddress = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 ,
LEN(PropertyAddress))

select *
from NashvilleHousing



select OwnerAddress
from NashvilleHousing


select
PARSENAME(REPLACE(OwnerAddress, ',','.'),3),
PARSENAME(REPLACE(OwnerAddress, ',','.'),2),
PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
from NashvilleHousing


Alter table nashvilleHousing
Add OwnerRealAddress nvarchar(255);

update NashvilleHousing
set OwnerRealAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)

Alter table nashvilleHousing
Add OwnerCityAddress nvarchar(255);

update NashvilleHousing
set OwnerCityAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)


Alter table nashvilleHousing
Add OwnerStateAddress nvarchar(255);

update NashvilleHousing
set OwnerStateAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)


select *
from NashvilleHousing

-- Changig some distinct valuses to match one another


select SoldAsVacant,
	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END
FROM NashvilleHousing


update NashvilleHousing
set SoldAsVacant =
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END

select distinct(SoldAsVacant), count(SoldAsVacant)
from NashvilleHousing
Group by SoldAsVacant


-- Remove Duplicates
WITH RowNumCTE AS (
select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID
				 ) row_num
From NashvilleHousing
)

SELECT *
From RowNumCTE
where row_num >1




-- Delete columns that are not used

Select *
from NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN  SaleDate






























