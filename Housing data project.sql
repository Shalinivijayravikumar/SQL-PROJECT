/*

Cleaning Data in SQL queries

*/

select * from PortfolioProject..Nashvillehousing

--Standardize date form----

select SaleDate from PortfolioProject..Nashvillehousing

select SaleDateconverted,CONVERT(Date,SaleDate) 
from PortfolioProject..Nashvillehousing

update PortfolioProject..Nashvillehousing
set SaleDate=CONVERT(Date,SaleDate)

alter table PortfolioProject..Nashvillehousing
add SaleDateconverted date

update PortfolioProject..Nashvillehousing
set SaleDateconverted=CONVERT(Date,SaleDate)

--populate Property Address-----

select PropertyAddress 
from PortfolioProject..Nashvillehousing
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,
ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..Nashvillehousing a
join PortfolioProject..Nashvillehousing b
  on a.ParcelID=b.ParcelID
  and a.[UniqueID ]<>b.[UniqueID ]
  where a.PropertyAddress is null

update a
set PropertyAddress= ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..Nashvillehousing a
join PortfolioProject..Nashvillehousing b
  on a.ParcelID=b.ParcelID
  and a.[UniqueID ]<>b.[UniqueID ]
  where a.PropertyAddress is null

  --breaking out Address into single column(Address,City,State)--

select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as address
from PortfolioProject..Nashvillehousing

select * from PortfolioProject..Nashvillehousing

--separating City column----
select  CITY =SUBSTRING(PropertyAddress,Charindex(',',PropertyAddress)+1,LEN(PropertyAddress))
from PortfolioProject..Nashvillehousing

ALTER TABLE PortfolioProject..Nashvillehousing
drop column CITY

alter table PortfolioProject..Nashvillehousing
add PROPERTYSPLITCITY varchar(255)

update PortfolioProject..Nashvillehousing
set PROPERTYSPLITCITY =SUBSTRING(PropertyAddress,Charindex(',',PropertyAddress)+1,LEN(PropertyAddress))

--separating Address Column----
select SUBSTRING(PropertyAddress,1,Charindex(',',PropertyAddress)-1)as Address
from PortfolioProject..Nashvillehousing

alter table PortfolioProject..Nashvillehousing
drop column Address

alter table PortfolioProject..Nashvillehousing
add PropertySplitAddress varchar(255)

update PortfolioProject..Nashvillehousing
set PropertySplitAddress =SUBSTRING(PropertyAddress,1,Charindex(',',PropertyAddress)-1)

select * from PortfolioProject..Nashvillehousing

--separating city----

select SUBSTRING(PropertyAddress,Charindex(',',PropertyAddress)+2,2)as State
from PortfolioProject..Nashvillehousing

alter table PortfolioProject..Nashvillehousing
drop column State

alter table PortfolioProject..Nashvillehousing
add PropertysplitState varchar(255)

update PortfolioProject..Nashvillehousing
set PropertysplitState =SUBSTRING(PropertyAddress,Charindex(',',PropertyAddress)+2,2)

select * from PortfolioProject..Nashvillehousing

----separating Address,City,State from OwnerAddress column----

SELECT Parsename(REPLACE(OwnerAddress,',','.'),3)as Address,
Parsename(REPLACE(OwnerAddress,',','.'),2) as City,
Parsename(REPLACE(OwnerAddress,',','.'),1) as State
from PortfolioProject..Nashvillehousing

alter table PortfolioProject..Nashvillehousing
add OwnerSplitAddress varchar(255),OwnerSplitCity varchar(255),OwnerSplitState varchar(255)

update PortfolioProject..Nashvillehousing
set OwnerSplitAddress=Parsename(REPLACE(OwnerAddress,',','.'),3),
OwnerSplitCity=Parsename(REPLACE(OwnerAddress,',','.'),2),
OwnerSplitState=Parsename(REPLACE(OwnerAddress,',','.'),1)

select * from PortfolioProject..Nashvillehousing


--Replacing  from 'Y' value  to 'Yes' and from 'N' value  to 'No'  in SoldAsVacant column--

SELECT SoldAsVacant from PortfolioProject..Nashvillehousing
where SoldAsVacant ='N'

update PortfolioProject..Nashvillehousing
set SoldAsVacant = case
when SoldAsVacant ='Y' then 'Yes'
when SoldAsVacant ='N' then 'No'
else SoldAsVacant
end

select SoldAsVacant,COUNT(SoldAsVacant)
from PortfolioProject..Nashvillehousing
group by SoldAsVacant
order by SoldAsVacant


--Removing Duplicates--
select * from PortfolioProject..Nashvillehousing


with ROW_NUMCTE as(
select *, 
row_number()
over(partition by ParcelID,SaleDate,SalePrice,LegalReference
order by uniqueID)Row_Num
from PortfolioProject..Nashvillehousing
)
 delete from ROW_NUMCTE 
where ROW_NUM >1
--order by PropertyAddress

select * from PortfolioProject..Nashvillehousing


-- checking Duplicates --
with ROW_NUMCTE as(
select *, 
row_number()
over(partition by ParcelID,SaleDate,SalePrice,LegalReference
order by uniqueID)Row_Num
from PortfolioProject..Nashvillehousing
)
select * from ROW_NUMCTE 
where ROW_NUM >1
--order by PropertyAddress


--Removing unused columns

alter table PortfolioProject..Nashvillehousing
drop column OwnerAddress,TaxDistrict,PropertyAddress,SaleDate

select * from PortfolioProject..Nashvillehousing


