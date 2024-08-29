/*

Cleaning Data in SQL Queries 

*/
select *
from portfolioproject.dbo.NashvilleHousing
------------------------------------------------------------------------

--Standardize Date Formate 


select SaleDate , CONVERT(date,SaleDate)
from portfolioproject.dbo.NashvilleHousing




update NashvilleHousing
set SaleDate = CONVERT(date,SaleDate)

alter table NashvilleHousing
add SaleDate2 Date;

update NashvilleHousing
set SaleDate2 =  CONVERT(date,SaleDate)



select SaleDate2 , CONVERT(date,SaleDate)
from portfolioproject.dbo.NashvilleHousing


------------------------------------------------------------------------

--Populate Property Adreass date  

select *
from portfolioproject.dbo.NashvilleHousing
--where PropertyAddress is null 
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID ,b.PropertyAddress , isnull (a.PropertyAddress,b.PropertyAddress)
from portfolioproject.dbo.NashvilleHousing a
join portfolioproject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull (a.PropertyAddress,b.PropertyAddress)
from portfolioproject.dbo.NashvilleHousing a
join portfolioproject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

select PropertyAddress,OwnerAddress
from portfolioproject.dbo.NashvilleHousing


select 
SUBSTRING (PropertyAddress ,1,CHARINDEX (',',PropertyAddress)-1) as Addreass
,SUBSTRING (PropertyAddress ,CHARINDEX (',',PropertyAddress)+1,LEN(PropertyAddress))as City
from portfolioproject.dbo.NashvilleHousing


alter table NashvilleHousing
add PropertysplitAddress nvarchar(255);

update NashvilleHousing
set PropertysplitAddress = SUBSTRING (PropertyAddress ,1,CHARINDEX (',',PropertyAddress)-1) ; 


alter table NashvilleHousing
add PropertySplitCity nvarchar(255);

update NashvilleHousing
set PropertySplitCity = SUBSTRING (PropertyAddress ,CHARINDEX (',',PropertyAddress)+1,LEN(PropertyAddress))
 

select OwnerAddress
from portfolioproject.dbo.NashvilleHousing

select 
PARSENAME(replace (OwnerAddress,',','.'),3)
,PARSENAME(replace (OwnerAddress,',','.'),2)
,PARSENAME(replace (OwnerAddress,',','.'),1)
from portfolioproject.dbo.NashvilleHousing


alter table NashvilleHousing 
add OwnerSplitAddress nvarchar(255);

update NashvilleHousing 
set OwnerSplitAddress = PARSENAME(replace (OwnerAddress,',','.'),3)


alter table NashvilleHousing 
add OwnerSplitCity nvarchar (255);

update NashvilleHousing 
set OwnerSplitCity = PARSENAME(replace (OwnerAddress,',','.'),2)


alter table [NashvilleHousing ]
add OwnerSplitState nvarchar (255);

update NashvilleHousing 
set OwnerSplitState = PARSENAME(replace (OwnerAddress,',','.'),3)




------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

select Distinct (SoldAsVacant) , count(SoldAsVacant)
from portfolioproject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2


select SoldAsVacant
 , case when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N'then  'No'
		else SoldAsVacant 
		end
from portfolioproject.dbo.NashvilleHousing 


update NashvilleHousing
set SoldAsVacant =case when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N'then  'No'
		else SoldAsVacant 
		end 


------------------------------------------------------------------------

-- Remove Duplicates
with RowNumCTE as (
select * 
	,ROW_NUMBER() over (
	PARTITION BY PArcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by
				 UniqueId
				 )row_num

from portfolioproject.dbo.NashvilleHousing
)
select*
from RowNumCTE
where row_num =1
order by PropertyAddress



------------------------------------------------------------------------

--Delete Unused Columns


select *
from portfolioproject.dbo.NashvilleHousing


alter table portfolioproject.dbo.NashvilleHousing
drop column PropertyAddress, OwnerAddress , TaxDistrict

alter table portfolioproject.dbo.NashvilleHousing
drop column SaleDate
























