/*
 *       {_       {__       {__{_______              {__      {__
 *      {_ __     {_ {__   {___{__    {__             {__   {__  
 *     {_  {__    {__ {__ { {__{__    {__     {__      {__ {__   
 *    {__   {__   {__  {__  {__{_ {__       {_   {__     {__     
 *   {______ {__  {__   {_  {__{__  {__    {_____ {__  {__ {__   
 *  {__       {__ {__       {__{__    {__  {_         {__   {__  
 * {__         {__{__       {__{__      {__  {____   {__      {__
 *
 */

#ifndef _IRREGFABFACTORY_H___
#define _IRREGFABFACTORY_H___

#include <cmath>
#include <cstdlib>
#include "AMReX_EBISLayout.H"
#include "AMReX_IrregFAB.H"
#include "AMReX_LayoutData.H"

namespace amrex
{
/// Factory class to produce IrregFABs.
/**
   Factory class to produce IrregFABs.
   This is needed for LevelData construction.
*/
  class IrregFABFactory
    : public FabFactory<IrregFAB>
  {
  public:
    /// factory function.
    /**
       Creates a new baseIrregFAB object
       and returns a pointer to it.  Responsiblitly
       for calling operator 'delete' on this pointer is passed to the user.
    */
    virtual IrregFAB* create (const Box& box, int ncomps, const FabInfo& info, int box_index) const;

    ///
    IrregFABFactory(const EBISLayout                          & a_ebisl, 
                    const shared_ptr<LayoutData<IntVectSet> > & a_sets)
      {
        m_graphs = a_ebisl.getAllGraphs();
        m_sets   = a_sets;
      }
    
    ///
    IrregFABFactory(const EBISLayout& a_ebisl)
      {
        m_graphs = a_ebisl.getAllGraphs();
        m_sets = shared_ptr<LayoutData<IntVectSet> >
          (new LayoutData<IntVectSet>(a_ebisl.getDBL(), a_ebisl.getDM()));
        for(MFIter mfi(*m_graphs); mfi.isValid(); ++mfi)
        {
          Box grid = a_ebisl.getDBL()[mfi];
          (*m_sets)[mfi] = (*m_graphs)[mfi].getIrregCells(grid); 
        }
      }

    ///
    IrregFABFactory()
      {
      }

    ///
    virtual ~IrregFABFactory()
      { }

  protected:
    shared_ptr<FabArray<EBGraph> > m_graphs;
    shared_ptr<LayoutData<IntVectSet> > m_sets;

  };

}
#endif
