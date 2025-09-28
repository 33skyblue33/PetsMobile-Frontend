using Microsoft.AspNetCore.Mvc;
using PetsMobile.Entities;

namespace PetsMobile.Repository.Interface
{
    public interface IUnitOfWork
    {
        Task<int> CompleteAsync();
    }
}
